import Foundation

protocol SavingsAccountRepository {
    func save(_ account: SaveingsAccount)
    func findByUserId(_ userId: UUID) -> SaveingsAccount?
    
}
