import Foundation

protocol CurrentAccountRepository {
    func save(_ account: CurrentAccount)
    func findByAccountNumber(_ id: UUID) -> CurrentAccount?
    func findByUserId(_ userId: UUID) -> CurrentAccount?
}

