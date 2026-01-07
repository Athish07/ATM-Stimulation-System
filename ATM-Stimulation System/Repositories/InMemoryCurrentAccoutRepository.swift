import Foundation

class InMemoryCurrentAccoutRepository: CurrentAccountRepository {

    private var currentAccounts: [UUID: Account] = [:]

    func save(account: Account) {
        currentAccounts[account.accountNumber] = account
    }

    func findById(accountNumber: UUID) -> Account? {
        currentAccounts.values.first { $0.accountNumber == accountNumber }
    }
}
