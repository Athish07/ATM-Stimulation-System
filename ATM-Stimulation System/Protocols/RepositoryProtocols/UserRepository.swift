import Foundation

protocol UserRepository {
    func save(_ user: User)
    func findById(userId: UUID) -> User?
    func findByEmail(_ email: String) -> User?
    func findByPhoneNumber(_ phoneNumber: String) -> User?
    
}
