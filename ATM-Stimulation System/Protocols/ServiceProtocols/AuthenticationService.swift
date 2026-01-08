import Foundation

enum LoginType: String, CaseIterable {
    case email = "Email"
    case phoneNumber = "PhoneNumber"
    
}

protocol AuthenticationService {

    func login(type: LoginType,identifier: String, password: String) throws -> User
    func register(
        name: String,
        email: String,
        password: String,
        phoneNumber: String
    ) throws
}
