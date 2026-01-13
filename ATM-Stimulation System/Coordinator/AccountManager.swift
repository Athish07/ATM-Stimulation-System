import Foundation

final class AccountManager: AccountCoordinator {
    
    private let currentAccountService: CurrentAccountManager
    private let savingsAccountService: SavingsAccountManager
    private let accountRepository: AccountRepository
    private let transactionRepository: TransactionRepository
    
    init(accountRepository: AccountRepository, transactionRepository: TransactionRepository,currentAccountService: CurrentAccountManager, savingsAccountService: SavingsAccountManager) {
        self.accountRepository = accountRepository
        self.transactionRepository = transactionRepository
        self.currentAccountService = currentAccountService
        self.savingsAccountService = savingsAccountService
    }
    
    func createAccount(
        bankName: String,
        userId: UUID,
        accountType: AccountType,
        bankLocation: String,
        pin: String
    ) throws -> Account {
        
        switch accountType {

        case .current:
            return currentAccountService.createAccount(
                bankName: bankName,
                userId: userId,
                bankLocation: bankLocation,
                pin: pin
            )
        case .savings:
            return savingsAccountService.createAccount(
                bankName: bankName,
                userId: userId,
                bankLocation: bankLocation,
                pin: pin
            )
        }
        
    }
    
    func deposit(
        to accountNumber: UUID,
        pin: String,
        amount: Double
    ) throws {
        
        let service = serviceForAccount(accountNumber)
        
        do {
            try service.deposit(to: accountNumber, pin: pin, amount: amount)
            
            recordTransaction(
                accountNumber: accountNumber,
                amount: amount,
                type: .deposit
            )
        } catch {
            
            recordTransaction(
                accountNumber: accountNumber,
                amount: amount,
                type: .deposit,
                status: .failed(reason: error.localizedDescription)
            )
            throw error
        }
    }
    
    func withdraw(
        from accountNumber: UUID,
        pin: String,
        amount: Double
    ) throws {
        
        let service = serviceForAccount(accountNumber)
        
        do {
            try service.withdraw(from: accountNumber, pin: pin, amount: amount)
            recordTransaction(
                accountNumber: accountNumber,
                amount: -amount,
                type: .withdrawal
            )
        } catch {
            recordTransaction(
                accountNumber: accountNumber,
                amount: -amount,
                type: .withdrawal,
                status: .failed(reason: error.localizedDescription)
            )
            throw error
        }
    }
    
    func transfer(
        from source: UUID,
        to destination: UUID,
        pin: String,
        amount: Double
    ) throws {
        
        try withdraw(from: source, pin: pin, amount: amount)
        
        do {
            try deposit(to: destination, pin: pin, amount: amount)
            
        } catch {
            try? deposit(to: source, pin: pin, amount: amount)
            throw error
        }
        
        recordTransaction(
            accountNumber: source,
            counterAccountNumber: destination,
            amount: -amount,
            type: .transfer
        )

        recordTransaction(
            accountNumber: destination,
            counterAccountNumber: source,
            amount: amount,
            type: .transfer
        )
        
    }
    
    func getAccounts(for userId: UUID) -> [Account] {
        accountRepository.findByUserId(userId)
    }
    
    func getTransactionHistory(for accountNumber: UUID) -> [Transaction] {
        transactionRepository.findByAccountNumber(accountNumber)
    }
    
}

extension AccountManager {

    private func serviceForAccount(_ accountNumber: UUID) -> AccountService {
        guard let account = accountRepository.findByAccountNumber(accountNumber) else {
            fatalError("Account not found")
        }

        if account is CurrentAccount {
            return currentAccountService
        } else {
            return savingsAccountService
        }
    }

    private func recordTransaction(
        accountNumber: UUID,
        counterAccountNumber: UUID? = nil,
        amount: Double,
        type: Transaction.TransactionType,
        status: Transaction.TransactionStatus = .completed
    ) {
        let transaction = Transaction(
            accountNumber: accountNumber,
            counterAccountNumber: counterAccountNumber,
            amount: amount,
            type: type,
            status: status
        )
        transactionRepository.save(transaction)
    }

}
