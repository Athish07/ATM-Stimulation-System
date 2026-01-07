import Foundation

class InMemoryAccountRepository: AccountRepository {
    
    private var accounts: [UUID: Account] = [:]

    func save(account: Account) {
        accounts[account.accountNumber] = account
    }

    func findById(userId: UUID) -> Account? {
        accounts.values.first { $0.userId == userId }
    }

}
