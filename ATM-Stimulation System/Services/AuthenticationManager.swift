import Foundation

final class AuthenticationManager: AuthenticationService {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func login(type: LoginType, identifier: String, password: String) throws -> User {
        
        let user: User
        
        switch type {
            
        case .email:
            guard let foundUser = userRepository.findByEmail(identifier)
            else {
                throw AuthenticationError.invalidUser
            }
            user = foundUser
            
        case .phoneNumber:
            guard let foundUser = userRepository.findByPhoneNumber(identifier)
            else {
                throw AuthenticationError.invalidUser
            }
            user = foundUser

        }
        
        guard user.password == password else {
            throw AuthenticationError.invalidPassword
        }
        
        return user
    }
    
    func register(
        name: String,
        email: String,
        password: String,
        phoneNumber: String
    ) throws {
        
        if userRepository.findByEmail(email) != nil {
            throw AuthenticationError.userAlreadyExists
        }
        
        let user = User(
            name: name,
            email: email,
            password: password,
            phoneNumber: phoneNumber
        )
        userRepository.save(user)
    }
}

extension AuthenticationManager {
    
    enum AuthenticationError: LocalizedError {
        case invalidUser
        case invalidPassword
        case userAlreadyExists
        
        var errorDescription: String? {
            switch self {
            case .invalidUser: return "Invalid userName or Password"
            case .invalidPassword: return "Invalid password"
            case .userAlreadyExists: return "Account already exists"
            }
        }
    }
    
}
