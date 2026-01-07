import Foundation

class InMemoryTransactionRepository: TransactionRepository {
    
    private let transactions: [UUID: Transaction] = [:]

    func getAll() -> [Transaction] {
        return transactions.values
            .sorted { $0.date > $1.date }

    }

    func findById(transactionId: UUID) -> Transaction? {
        return transactions[transactionId]
    }

    func findByAccountNumber(accountNumber: UUID) -> Transaction? {
        return transactions.values.first {
            $0.fromAccoutNumber == accountNumber
                || $0.toAccountNumber == accountNumber
        }
    }
    
}
