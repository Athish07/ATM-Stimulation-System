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
            id: updatedUser.id,
            name: updatedUser.name.isEmpty ? existing.name : updatedUser.name,
            email: updatedUser.email.isEmpty
            ? existing.email : updatedUser.email,
            passwordHash: existing.passwordHash,
            phoneNumber: updatedUser.phoneNumber.isEmpty
            ? existing.phoneNumber
            : updatedUser.phoneNumber
        )
        
        if merged == existing {
            throw UserManagerError.noChangeDetected
        }
        
        userRepository.save(merged)
        
    }
    
    func updatePassword(newPassword: String, user: inout User) throws {
        
        if user.passwordHash == SecretHasher.hash(newPassword) {
            throw UserManagerError.noChangeDetected
        }
            
        user.setPassword(newPassword)
        userRepository.save(user)
    }
}

extension UserManager {

    enum UserManagerError: LocalizedError {

        case userNotFound
        case noChangeDetected

        var errorDescription: String? {
            switch self {
            case .userNotFound: return "Unable to update the details"
            case .noChangeDetected: return "No change detected."
            }
        }
    }
}
