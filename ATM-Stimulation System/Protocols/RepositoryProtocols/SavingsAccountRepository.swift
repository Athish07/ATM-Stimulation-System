import Foundation

protocol SavingsAccountRepository {
    func save(account: Saveings) 
    func findById(accountNumber: UUID) -> Saveings?
    
}
