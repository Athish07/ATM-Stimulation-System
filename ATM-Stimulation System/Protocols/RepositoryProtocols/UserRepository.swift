import Foundation

protocol UserRepository {
    func save(user: User)
    func findById(userId: UUID) -> User?
    func findByEmail(email: String) -> User?
    func findByPhoneNumber(phoneNumber: String) -> User?
    
}
