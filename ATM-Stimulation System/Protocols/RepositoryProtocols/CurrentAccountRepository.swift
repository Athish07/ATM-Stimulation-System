import Foundation

protocol CurrentAccountRepository {
    func save(account: Current)
    func findById(accountNumber: UUID) -> Current?
    
}
