import Foundation

final class InMemoryTransactionRepository: TransactionRepository {
    
    private let transactions: [UUID: [Transaction]] = [:]

    
}
