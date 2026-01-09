import Foundation

final class AccountManager {
    
    private let currentAccountRepository: CurrentAccountRepository
    private let savingsAccountRepository: SavingsAccountRepository
    private let transactionRepository: TransactionRepository
    private let overDraftLimit: Double = 10_000
    
    init(
        currentAccountRepository: CurrentAccountRepository,
        savingsAccountRepository: SavingsAccountRepository,
        transactionRepository: TransactionRepository
    ) {
        self.currentAccountRepository = currentAccountRepository
        self.savingsAccountRepository = savingsAccountRepository
        self.transactionRepository = transactionRepository
    }
    
    func createAccount(
        userId: UUID,
        type: AccountType,
        bankName: String,
        bankLocation: String,
        pin: String
    ) -> AccountDetails {
        
        switch type {
        case .savings:
            return createSavingsAccount(
                userId: userId,
                bankName: bankName,
                bankLocation: bankLocation,
                pin: pin
            )
            
        case .current:
            return createCurrentAccount(
                userId: userId,
                bankName: bankName,
                bankLocation: bankLocation,
                pin: pin
            )
        }
    }
    
    func deposit(
        to accountNumber: UUID,
        amount: Double,
        pin: String
    ) throws {
        
        guard amount > 0 else {
            throw AccountError.invalidAmount
        }
        
        if try depositToCurrent(accountNumber, amount, pin) { return }
        if try depositToSavings(accountNumber, amount, pin) { return }
        
        throw AccountError.accountNotFound
    }
    
    func withdraw(
        from accountNumber: UUID,
        amount: Double,
        pin: String
    ) throws {
        
        guard amount > 0 else {
            throw AccountError.invalidAmount
        }
        
        if try withdrawFromCurrent(accountNumber, amount, pin) { return }
        if try withdrawFromSavings(accountNumber, amount, pin) { return }
        
        throw AccountError.accountNotFound
    }
    
    func transfer(
        from sourceAccount: UUID,
        to destinationAccount: UUID,
        amount: Double,
        pin: String
    ) throws {
        
        guard sourceAccount != destinationAccount else {
            throw AccountError.invalidAmount
        }
        
        try withdraw(
            from: sourceAccount,
            amount: amount,
            pin: pin
        )
        
        do {
            try deposit(
                to: destinationAccount,
                amount: amount,
                pin: pin
            )
        } catch {
            // Attempt rollback
            _ = try? deposit(
                to: sourceAccount,
                amount: amount,
                pin: pin
            )
            throw error
        }
        
        record(
            accountNumber: sourceAccount,
            counterAccountNumber: destinationAccount,
            amount: amount,
            type: .transfer
        )
        
        record(
            accountNumber: destinationAccount,
            counterAccountNumber: sourceAccount,
            amount: amount,
            type: .transfer
        )
    }
}

// extension for creating different accounts.
private extension AccountManager {
    
    func createSavingsAccount(
        userId: UUID,
        bankName: String,
        bankLocation: String,
        pin: String
    ) -> AccountDetails {
        
        let account = SavingsAccount(
            bankName: bankName,
            userId: userId,
            bankLocation: bankLocation,
            pin: pin
        )
        
        savingsAccountRepository.save(account)
        
        return AccountDetails(
            accountNumber: account.accountNumber,
            accountType: .savings,
            bankName: bankName,
            bankLocation: bankLocation,
            balance: account.balance
        )
    }
    
    func createCurrentAccount(
        userId: UUID,
        bankName: String,
        bankLocation: String,
        pin: String
    ) -> AccountDetails {
        
        let account = CurrentAccount(
            bankName: bankName,
            userId: userId,
            bankLocation: bankLocation,
            pin: pin,
            overdraftLimit: overDraftLimit
        )
        
        currentAccountRepository.save(account)
        
        return AccountDetails(
            accountNumber: account.accountNumber,
            accountType: .current,
            bankName: bankName,
            bankLocation: bankLocation,
            balance: account.balance
        )
    }
}

// extension for performing deposite operations.
extension AccountManager {

    func depositToCurrent(
        _ accountNumber: UUID,
        _ amount: Double,
        _ pin: String
    ) throws -> Bool {

        guard
            var account =
                currentAccountRepository.findByAccountNumber(accountNumber)
        else { return false }

//        guard account.verifyPin(pin) else {
//            throw AccountError.incorrectPin
//        }

        account.deposit(amount)
        currentAccountRepository.save(account)

        record(
            accountNumber: accountNumber,
            amount: amount,
            type: .deposit
        )
        return true
    }

    func depositToSavings(
        _ accountNumber: UUID,
        _ amount: Double,
        _ pin: String
    ) throws -> Bool {

        guard
            var account =
                savingsAccountRepository.findByAccountNumber(accountNumber)
        else { return false }

//        guard account.verifyPin(pin) else {
//            throw AccountError.incorrectPin
//        }

        account.deposit(amount)
        savingsAccountRepository.save(account)

        record(
            accountNumber: accountNumber,
            amount: amount,
            type: .deposit
        )
        return true
    }
}


// extension for performing withdrawing operations.
extension AccountManager {

    fileprivate func withdrawFromCurrent(
        _ accountNumber: UUID,
        _ amount: Double,
        _ pin: String
    ) throws -> Bool {

        guard
            var account =
                currentAccountRepository.findByAccountNumber(accountNumber)
        else { return false }

//        guard account.verifyPin(pin) else {
//            throw AccountError.incorrectPin
//        }

        let newBalance = account.balance - amount
        guard newBalance >= -overDraftLimit else {
            throw AccountError.overdraftLimitExceeded
        }

        account.withdraw(amount)
        currentAccountRepository.save(account)

        record(
            accountNumber: accountNumber,
            amount: amount,
            type: .withdrawal
        )
        return true
    }

    fileprivate func withdrawFromSavings(
        _ accountNumber: UUID,
        _ amount: Double,
        _ pin: String
    ) throws -> Bool {

        guard
            var account =
                savingsAccountRepository.findByAccountNumber(accountNumber)
        else { return false }

//        guard account.verifyPin(pin) else {
//            throw AccountError.incorrectPin
//        }

        guard account.balance >= amount else {
            throw AccountError.insufficientBalance
        }

        account.withdraw(amount)
        savingsAccountRepository.save(account)

        record(
            accountNumber: accountNumber,
            amount: amount,
            type: .withdrawal
        )
        return true
    }
}

extension AccountManager {
    
    enum AccountError: LocalizedError {
        case accountNotFound
        case invalidAmount
        case incorrectPin
        case insufficientBalance
        case overdraftLimitExceeded
        
        var errorDescription: String? {
            switch self {
            case .accountNotFound:
                return "Account not found."
            case .invalidAmount:
                return "Invalid amount entered."
            case .incorrectPin:
                return "Incorrect PIN."
            case .insufficientBalance:
                return "Insufficient balance."
            case .overdraftLimitExceeded:
                return "Overdraft limit exceeded."
            }
        }
    }
    
    func record(
        accountNumber: UUID,
        counterAccountNumber: UUID? = nil,
        amount: Double,
        type: TransactionType
    ) {
        let transaction = Transaction(
            accountNumber: accountNumber,
            counterAccountNumber: counterAccountNumber,
            amount: amount,
            type: type
        )
        transactionRepository.save(transaction)
    }
    
}
