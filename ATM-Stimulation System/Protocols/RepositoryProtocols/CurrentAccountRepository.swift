import Foundation

protocol CurrentAccountRepository {
    func save(_ account: CurrentAccount)
    func findByUserId(_ userId: UUID) -> CurrentAccount?
    
}
