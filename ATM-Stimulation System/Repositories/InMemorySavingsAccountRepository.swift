import Foundation

class InMemorySavingsAccountRepository: SavingsAccountRepository {

    private var saveingsAccounts: [UUID: Account] = [:]

    func save(account: Account) {
        saveingsAccounts[account.accountNumber] = account
    }

    func findById(accountNumber: UUID) -> Account? {
        saveingsAccounts.values.first {
            $0.accountNumber == accountNumber
        }
    }

}
