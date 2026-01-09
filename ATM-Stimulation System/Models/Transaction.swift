import Foundation

struct Transaction {
    
    let id: UUID
    let accountNumber: UUID
    let counterAccountNumber: UUID?
    let amount: Double
    let type: TransactionType
    let date: Date

    init(
        accountNumber: UUID,
        counterAccountNumber: UUID? = nil,
        amount: Double,
        type: TransactionType
    ) {
        self.id = UUID()
        self.accountNumber = accountNumber
        self.counterAccountNumber = counterAccountNumber
        self.date = Date()
        self.amount = amount
        self.type = type
    }

}

extension Transaction {
    
    enum TransactionType {
        case deposit
        case withdrawal
        case transfer
    }
}
typealias TransactionType = Transaction.TransactionType
