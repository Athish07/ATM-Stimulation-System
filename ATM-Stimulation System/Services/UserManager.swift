import Foundation

final class UserManager: UserService {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func getUserById(_ userId: UUID) -> User? {
        userRepository.findById(userId)
    }
    
    
}

