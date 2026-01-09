import Foundation

final class InMemorySavingsAccountRepository: SavingsAccountRepository {

    private var storage: [UUID: SavingsAccount] = [:]

    func save(_ account: SavingsAccount) {
        storage[account.accountNumber] = account
    }

    func findByAccountNumber(_ id: UUID) -> SavingsAccount? {
        storage[id]
    }

    func findByUserId(_ userId: UUID) -> SavingsAccount? {
        storage.values.first { $0.userId == userId }
    }
}

