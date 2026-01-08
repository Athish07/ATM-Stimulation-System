import Foundation

class InMemoryCurrentAccountRepository: CurrentAccountRepository {
    
    private var currentAccounts: [UUID: CurrentAccount] = [:]

    func save(_ account: CurrentAccount) {
        currentAccounts[account.accountNumber] = account
    }

    func findByUserId(_ userId: UUID) -> CurrentAccount? {
        currentAccounts.values.first { $0.userId == userId }
    }

}
