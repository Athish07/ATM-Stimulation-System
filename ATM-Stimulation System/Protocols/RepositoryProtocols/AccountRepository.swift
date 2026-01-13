import Foundation

protocol AccountRepository {
    func save(_ account: Account)
    func findByAccountNumber(_ accountNumber: UUID) -> Account?
    func findByUserId(_ userId: UUID) -> [Account]
    func getAllAccounts() -> [Account]
}
