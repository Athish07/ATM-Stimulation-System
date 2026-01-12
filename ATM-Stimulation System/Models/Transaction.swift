import Foundation

struct Transaction {
    
    let id: UUID
    let accoutNumber: UUID
    let counterAccountNumber: UUID?
    let amount: Double
    let type: TransactionType
    let status: TransactionStatus
    let date: Date

    init(
        accoutNumber: UUID,
        counterAccountNumber: UUID? = nil,
        amount: Double,
        type: TransactionType,
        status: TransactionStatus
    ) {
        self.id = UUID()
        self.accoutNumber = accoutNumber
        self.counterAccountNumber = counterAccountNumber
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
