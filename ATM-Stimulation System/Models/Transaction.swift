import Foundation

struct Transaction {
    
    let id: UUID
    let fromAccountNumber: UUID
    let toAccountNumber: UUID
    let amount: Double
    let type: TransactionType
    let status: TransactionStatus
    let date: Date

    init(
        fromAccountNumber: UUID,
        toAccountNumber: UUID,
        amount: Double,
        type: TransactionType,
        status: TransactionStatus
    ) {
        self.id = UUID()
        self.fromAccountNumber = fromAccountNumber
        self.toAccountNumber = toAccountNumber
        self.date = Date()
        self.amount = amount
        self.type = type
        self.status = status
    }

}

extension Transaction {
    
    enum TransactionType {
        case deposit
        case withdrawal
        case transfer
    }

    enum TransactionStatus {
        case completed
        case failed(reason: String)
    }
}

typealias TransactionType = Transaction.TransactionType
typealias TransactionStatus = Transaction.TransactionStatus
