import Foundation

final class InMemoryAccountRepository: AccountRepository {

    private var accounts: [UUID: Account] = [:]

    func save(_ account: Account) {
        accounts[account.accountNumber] = account
    }

    func findByAccountNumber(_ accountNumber: UUID) -> Account? {
        accounts[accountNumber]
    }

    func findByUserId(_ userId: UUID) -> [Account] {
        accounts.values.filter { $0.userId == userId }
    }
    
}
