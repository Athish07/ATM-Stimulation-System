import Foundation

struct Account {

    let accountNumber: UUID
    var bankName: String
    let bankLocation: String
    let openedDate: Date
    private(set) var balance: Double
    let type: AccountType

    init(
        bankName: String,
        bankLocation: String,
        accountType: AccountType = AccountType.savings
    ) {
        self.accountNumber = UUID()
        self.bankName = bankName
        self.bankLocation = bankLocation
        self.openedDate = Date()
        self.balance = 0.0
        self.type = accountType

    }

}
extension Account {

    mutating func deposit(_ amount: Double) -> Bool {
        guard amount > 0 else { return false }
        balance += amount
        return true
    }

    mutating func withdraw(_ amount: Double) -> Bool {
        guard amount > 0 else { return false }

        let newBalance = balance - amount

        if type.allowOverDraft {
            balance = newBalance
            return true
        }

        if type.minimumBalance <= newBalance {
            balance = newBalance
            return true
        }

        return false
    }
}

extension Account {

    enum AccountType {
        case savings
        case current

        var minimumBalance: Double {
            switch self {
            case .savings: return 0
            case .current: return 1000

            }
        }

        var allowOverDraft: Bool {
            switch self {
            case .current: return true
            case .savings: return false
            }
        }
    }
}
