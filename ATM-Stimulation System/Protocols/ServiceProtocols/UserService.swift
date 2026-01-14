import Foundation

protocol UserService {
    func getUserById(_ userId: UUID) -> User?
    func updateProfile(_ updatedUser: User) throws
    func updatePassword(newPassword: String, user: inout User) 
    
}
