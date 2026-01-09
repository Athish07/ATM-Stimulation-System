import Foundation

final class InMemoryCurrentAccountRepository: CurrentAccountRepository {

    private var storage: [UUID: CurrentAccount] = [:]

    func save(_ account: CurrentAccount) {
        storage[account.accountNumber] = account
    }

    func findByAccountNumber(_ id: UUID) -> CurrentAccount? {
        storage[id]
    }

    func findByUserId(_ userId: UUID) -> CurrentAccount? {
        storage.values.first { $0.userId == userId }
    }
}

