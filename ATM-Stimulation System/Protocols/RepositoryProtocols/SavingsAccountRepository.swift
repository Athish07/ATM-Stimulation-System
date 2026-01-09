import Foundation

protocol SavingsAccountRepository {
    func save(_ account: SavingsAccount)
    func findByAccountNumber(_ id: UUID) -> SavingsAccount?
    func findByUserId(_ userId: UUID) -> SavingsAccount?
}

