import Foundation

protocol TransactionRepository {
    func save(_ transaction: Transaction)
    func getAll() -> [Transaction]
    func findById(transactionId: UUID) -> Transaction?
    func findByAccountNumber(accountNumber: UUID) -> Transaction?
    
}

