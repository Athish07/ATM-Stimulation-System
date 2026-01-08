import Foundation

class InMemorySavingsAccountRepository: SavingsAccountRepository {
    
    private var savingsAccounts: [UUID: SaveingsAccount] = [:]

    func save(_ account: SaveingsAccount) {
        savingsAccounts[account.accountNumber] = account
    }
    
    func findByUserId(_ userId: UUID) -> SaveingsAccount? {
        savingsAccounts.values.first { $0.userId == userId }
    }
    
}
