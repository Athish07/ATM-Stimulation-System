import Foundation

final class TransactionManager: TransactionService {

    private let transactionRepository: TransactionRepository
    private let currentAccountRepository: CurrentAccountRepository
    private let savingsAccountRepository: SavingsAccountRepository

    init(
        transactionRepository: TransactionRepository,
        currentAccountRepository: CurrentAccountRepository,
        savingsAccountRepository: SavingsAccountRepository
    ) {
        self.transactionRepository = transactionRepository
        self.currentAccountRepository = currentAccountRepository
        self.savingsAccountRepository = savingsAccountRepository
    }
    
    func deposit(
        userId: UUID,
        accountType: AccountType,
        amount: Double
    ) throws {

        guard amount > 0 else {
            throw TransactionError.depositOperationFailed
        }

        switch accountType {
        case .current:
            try depositOnCurrentAccount(userId: userId, amount: amount)
        case .savings:
            try depositOnSavingsAccount(userId: userId, amount: amount)
        }
    }

    func withdraw(
        userId: UUID,
        accountType: AccountType,
        amount: Double
    ) throws {

        guard amount > 0 else {
            throw TransactionError.withdrawOperationFailed
        }

        switch accountType {
        case .current:
            try withdrawalOnCurrentAccount(userId: userId, amount: amount)
        case .savings:
            try withdrawalOnSavingsAccount(userId: userId, amount: amount)
        }
    }
    
    private func depositOnCurrentAccount(
        userId: UUID,
        amount: Double
    ) throws {

        guard let account =
            currentAccountRepository.findByUserId(userId)
        else {
            throw TransactionError.accountNotFound
        }

        guard account.deposit(amount) else {
            throw TransactionError.depositOperationFailed
        }

        currentAccountRepository.save(account)

        recordTransaction(
            amount: amount,
            accountNumber: account.accountNumber,
            type: .deposit
        )
    }

    private func depositOnSavingsAccount(
        userId: UUID,
        amount: Double
    ) throws {
        
        guard let account =
                savingsAccountRepository.findByUserId(userId)
        else {
            throw TransactionError.accountNotFound
        }
        
        guard account.deposit(amount) else {
            throw TransactionError.depositOperationFailed
        }
        
        savingsAccountRepository.save(account)
        
        recordTransaction(
            amount: amount,
            accountNumber: account.accountNumber,
            type: .deposit
        )
        
    }
    
    private func withdrawalOnCurrentAccount(
        userId: UUID,
        amount: Double
    ) throws {

        guard let account =
            currentAccountRepository.findByUserId(userId)
        else {
            throw TransactionError.accountNotFound
        }

        guard account.withdraw(amount) else {
            throw TransactionError.withdrawOperationFailed
        }

        currentAccountRepository.save(account)

        recordTransaction(
            amount: amount,
            accountNumber: account.accountNumber,
            type: .withdrawal
        )
        
    }

    private func withdrawalOnSavingsAccount(
        userId: UUID,
        amount: Double
    ) throws {

        guard let account =
            savingsAccountRepository.findByUserId(userId)
        else {
            throw TransactionError.accountNotFound
        }

        guard account.withdraw(amount) else {
            throw TransactionError.withdrawOperationFailed
        }

        savingsAccountRepository.save(account)

        recordTransaction(
            amount: amount,
            accountNumber: account.accountNumber,
            type: .withdrawal
        )
    }
    
    private func recordTransaction(
        amount: Double,
        accountNumber: UUID,
        type: TransactionType
    ) {
        let transaction = Transaction(
            fromAccountNumber: accountNumber,
            toAccountNumber: accountNumber,
            amount: amount,
            type: type,
            status: .completed
        )
        transactionRepository.save(transaction)
    }
}

extension TransactionManager {

    enum AccountType {
        case savings
        case current
    }

    enum TransactionError: String, LocalizedError {
        case accountNotFound
        case depositOperationFailed
        case withdrawOperationFailed

        var errorDescription: String {
            switch self {
            case .accountNotFound:
                return "Account not found for the given user."
            case .depositOperationFailed:
                return "Deposit operation failed."
            case .withdrawOperationFailed:
                return "Withdraw operation failed."
            }
        }
    }
}

