import Foundation

protocol TransactionRepository {
    func getAll() -> [Transaction]
    func findById(transactionId: UUID) -> Transaction?
    func findByAccountNumber(accountNumber: UUID) -> Transaction?
    
}

