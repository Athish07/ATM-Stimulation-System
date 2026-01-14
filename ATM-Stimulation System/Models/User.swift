import Foundation

struct User: Equatable {

    let id: UUID
    let name: String
    let email: String
    private(set) var passwordHash: String
    let phoneNumber: String

    init(
        id: UUID = UUID(),
        name: String,
        email: String,
        password: String,
        phoneNumber: String
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.passwordHash = SecretHasher.hash(password)
        self.phoneNumber = phoneNumber
    }
    
    init(
            id: UUID,
            name: String,
            email: String,
            passwordHash: String,
            phoneNumber: String
        ) {
            self.id = id
            self.name = name
            self.email = email
            self.passwordHash = passwordHash
            self.phoneNumber = phoneNumber
        }
    
    
    mutating func setPassword(_ newPassword: String) {
        passwordHash = SecretHasher.hash(newPassword)
    }
}
