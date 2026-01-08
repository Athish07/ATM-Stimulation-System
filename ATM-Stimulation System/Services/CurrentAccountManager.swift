import Foundation

final class CurrentAccountManager: CurrentAccountService {

    typealias AccountType = CurrentAccount
    private let repository: CurrentAccountRepository

    init(repository: CurrentAccountRepository) {
        self.repository = repository
    }

    func deposit(userId: UUID, amount: Double) throws -> AccountType {
        let account = try findAccount(userId: userId)

        guard account.deposit(amount)
        else { throw TransactionError.depositOperationFailed }
        repository.save(account)
        return account
    }
    
    func withdraw(userId: UUID, amount: Double) throws -> AccountType {
        let account = try findAccount(userId: userId)

        guard account.withdraw(amount)
        else { throw TransactionError.withdrawOperationFailed }
        repository.save(account)
        return account
    }
    
    func findAccount(userId: UUID) throws -> AccountType {
        guard let account = repository.findByUserId(userId)
        else { throw TransactionError.accountNotFound }
        return account
    }
    
}

