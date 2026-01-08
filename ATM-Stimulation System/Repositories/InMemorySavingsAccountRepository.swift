import Foundation

class InMemorySavingsAccountRepository: SavingsAccountRepository {
    
    private var savingsAccounts: [UUID: SavingsAccount] = [:]

    func save(_ account: SavingsAccount) {
        savingsAccounts[account.accountNumber] = account
    }
    
    func findByUserId(_ userId: UUID) -> SavingsAccount? {
        savingsAccounts.values.first { $0.userId == userId }
    }
    
}
