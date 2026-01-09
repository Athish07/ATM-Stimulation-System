import Foundation

protocol TransactionRepository {
    func save(_ transaction: Transaction)
    func findByAccountNumber(_ accountNumber: UUID) -> [Transaction]
}

