import Foundation

class InMemoryUserRepository: UserRepository {

    private var users: [UUID: User] = [:]

    func save(user: User) {
        users[user.id] = user
    }

    func findById(userId: UUID) -> User? {
        users[userId]
    }

    func findByEmail(email: String) -> User? {
        users.values.first { $0.email == email }
    }

    func findByPhoneNumber(phoneNumber: String) -> User? {
        users.values.first { $0.phoneNumber == phoneNumber }
    }

}
