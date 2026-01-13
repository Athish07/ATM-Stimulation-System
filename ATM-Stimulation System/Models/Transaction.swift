import Foundation

struct Transaction {

    let id: UUID
    let accountNumber: UUID
    let counterAccountNumber: UUID?
    let amount: Double
    let type: TransactionType
    let status: TransactionStatus
    let date: Date

    init(
        accountNumber: UUID,
        counterAccountNumber: UUID? = nil,
        amount: Double,
        type: TransactionType,
        status: TransactionStatus
    ) {
        self.id = UUID()
        self.accountNumber = accountNumber
        self.counterAccountNumber = counterAccountNumber
        self.date = Date()
        self.amount = amount
        self.type = type
        self.status = status
    }

    func description() -> String {

        let accountInfo =
            counterAccountNumber == nil
            ? "Account        : XXX-XXX-\(accountNumber.uuidString.suffix(5))"
            :
            """
            From Account   : XXX-XXX-\(accountNumber.uuidString.suffix(5))
               To Account     : XXX-XXX-\(counterAccountNumber!.uuidString.suffix(5))
            """

        return """
            Type           : \(type.rawValue)
               Amount         : \(amount)
               Status         : \(status)
               \(accountInfo)
               Date           : \(date.formatted())
            ----------------------------------------
            """
    }
}

extension Transaction {
    
    enum TransactionType: String {
        case deposit = "Deposite"
        case withdrawal = "Withdrawal"
        case transfer = "Transfer"
    }
    
    enum TransactionStatus: Equatable {
        case completed
        case failed(reason: String)
    }
}
