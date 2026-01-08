import Foundation

final class TransactionManager: TransactionService {

    private let currentService: CurrentAccountService
    private let savingsService: SavingsAccountService
    private let transactionRepository: TransactionRepository
    
    init(
        currentService: CurrentAccountService,
        savingsService: SavingsAccountService,
        transactionRepository: TransactionRepository
    ) {
        self.currentService =  currentService
        self.savingsService = savingsService
        self.transactionRepository = transactionRepository
    }
    
    func deposit(
        userId: UUID,
        accountType: AccountType,
        amount: Double
    ) throws {

        let service = findService(for: accountType)
        let account = try service.deposit(userId: userId, amount: amount)
        
        recordTransaction(
            from: account.accountNumber,
            to: account.accountNumber,
            amount: amount,
            type: .deposit
        )
    }
    
    func withdraw(
        userId: UUID,
        accountType: AccountType,
        amount: Double
    ) throws {

        let service = findService(for: accountType)
        let account = try service.withdraw(userId: userId, amount: amount)

        recordTransaction(
            from: account.accountNumber,
            to: account.accountNumber,
            amount: amount,
            type: .withdrawal
        )
    }
    
    func transfer(
        fromUserId: UUID,
        fromType: AccountType,
        toUserId: UUID,
        toType: AccountType,
        amount: Double
    ) throws {

        let fromService = findService(for: fromType)
        let toService = findService(for: toType)
        
        let fromAccount = try fromService.findAccount(userId: fromUserId)
        let toAccount = try toService.findAccount(userId: toUserId)

        guard fromAccount.accountNumber != toAccount.accountNumber else {
            throw TransactionError.sameAccountTransferNotAllowed
        }

        guard fromAccount.withdraw(amount) else {
            throw TransactionError.withdrawOperationFailed
        }

        guard toAccount.deposit(amount) else {
            _ = fromAccount.deposit(amount)
            throw TransactionError.depositOperationFailed
        }

        recordTransaction(
            from: fromAccount.accountNumber,
            to: toAccount.accountNumber,
            amount: amount,
            type: .transfer
        )
    }

    private func findService<T: CurrentAccountService>(for type: AccountType) -> T {
        switch type {
        case .current:
            return currentService
        case .savings:
            return savingsService
        }
    }

    private func recordTransaction(
        from: UUID,
        to: UUID,
        amount: Double,
        type: TransactionType
    ) {
        let transaction = Transaction(
            fromAccountNumber: from,
            toAccountNumber: to,
            amount: amount,
            type: type,
            status: .completed
        )
        transactionRepository.save(transaction)
    }
}

extension TransactionManager {
    
}
