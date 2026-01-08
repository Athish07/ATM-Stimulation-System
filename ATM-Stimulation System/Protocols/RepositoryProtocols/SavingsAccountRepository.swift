import Foundation

protocol SavingsAccountRepository {
    func save(_ account: SavingsAccount)
    func findByUserId(_ userId: UUID) -> SavingsAccount?
    
}
