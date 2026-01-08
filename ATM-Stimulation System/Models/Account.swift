import Foundation

struct Account {

    let accountNumber: UUID
    let userId: UUID
    let bankName: String
    let bankLocation: String
    let openedDate: Date
    let minimumBalance: Double

    private(set) var balance: Double = 0.0

    init(
        bankName: String,
        userId: UUID,
        bankLocation: String,
        minimumBalance: Double,
    ) {
        self.accountNumber = UUID()
        self.userId = userId
        self.bankName = bankName
        self.bankLocation = bankLocation
        self.openedDate = Date()
        self.minimumBalance = minimumBalance
    }

    enum AccountType {
        case savings
        case current
    }

    mutating func deposit(_ amount: Double) -> Bool {
        guard amount > 0 else { return false }
        balance += amount
        return true
    }

    mutating func increaseBalance(_ amount: Double) {
        balance += amount
    }

    mutating func decreaseBalance(_ amount: Double) {
        balance -= amount
    }
}

typealias AccountType = Account.AccountType
