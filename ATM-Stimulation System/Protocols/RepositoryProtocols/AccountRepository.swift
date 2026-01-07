import Foundation

protocol AccountRepository {
    func save(account: Account)
    func findById(userId: UUID) -> Account?
    
}
