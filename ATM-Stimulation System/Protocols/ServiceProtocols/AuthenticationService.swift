import Foundation

enum LoginIdentifier {
    case email(String)
    case phoneNumber(String)
}

protocol AuthenticationService {

    func login(identifier: LoginIdentifier, password: String) throws -> User
    func register(
        name: String,
        email: String,
        password: String,
        phoneNumber: String
    ) throws
}
