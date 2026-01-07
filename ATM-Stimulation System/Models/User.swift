import Foundation

struct User: Equatable {

    let id: UUID
    let name: String
    let email: String
    let password: String
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
        self.password = password
        self.phoneNumber = phoneNumber
    }
}
