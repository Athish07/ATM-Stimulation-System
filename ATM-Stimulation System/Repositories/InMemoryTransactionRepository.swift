import Foundation

final class InMemoryTransactionRepository: TransactionRepository {
    private var transactions: [Transaction] = []
    
    func save(_ transaction: Transaction) {
        transactions.append(transaction)
    }
    
    func findByAccountNumber(_ accountNumber: UUID) -> [Transaction] {
        transactions.filter {
            $0.accountNumber == accountNumber || $0.counterAccountNumber == accountNumber
        }
        .sorted { $0.date > $1.date } 
    }
}
