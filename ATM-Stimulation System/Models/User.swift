import Foundation

struct User: Equatable {

    let id: UUID
    let name: String
    let email: String
    private let passwordHash: String
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
    
}

extension User {

    func verifyPassword(_ password: String) -> Bool {
        SecretHasher.verify(password,against: passwordHash)
    }
}

