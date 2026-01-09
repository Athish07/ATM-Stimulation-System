import Foundation

final class InMemoryTransactionRepository: TransactionRepository {

    private var storage: [UUID: [Transaction]] = [:]

    func save(_ transaction: Transaction) {
        storage[transaction.accountNumber, default: []]
            .append(transaction)
    }
    
    func findByAccountNumber(_ accountNumber: UUID) -> [Transaction] {
        storage[accountNumber] ?? []
    }
    
}
