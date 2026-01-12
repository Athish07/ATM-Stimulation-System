import Foundation

final class UserManager: UserService {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func getUserById(_ userId: UUID) -> User? {
        userRepository.findById(userId)
    }
    
    func updateProfile(_ updatedUser: User) throws {
        guard let existing = userRepository.findById(updatedUser.id) else {
            throw UserManagerError.userNotFound
        }
        
        let merged = User(
            id: existing.id,
            name: updatedUser.name.isEmpty ? existing.name : updatedUser.name,
            email: updatedUser.email.isEmpty ? existing.email : updatedUser.email,
            passwordHash: updatedUser.passwordHash.isEmpty
            ? existing.passwordHash
            : updatedUser.passwordHash,
            phoneNumber: updatedUser.phoneNumber.isEmpty
            ? existing.phoneNumber
            : updatedUser.phoneNumber
        )
        
        guard merged != existing else {
           throw UserManagerError.noChangeDetected
        }
        
        userRepository.save(merged)
        
    }

}

extension UserManager {
    
    enum UserManagerError: LocalizedError {
        
        case userNotFound
        case noChangeDetected
    }
}
