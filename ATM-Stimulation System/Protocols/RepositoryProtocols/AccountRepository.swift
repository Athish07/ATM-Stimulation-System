import Foundation

protocol AccountRepository {
    func save(_ account: Account)
    func findByNumber(_ accountNumber: UUID) -> Account?
    func findByUserId(_ userId: UUID) -> [Account]
    
}
