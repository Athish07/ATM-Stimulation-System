import Foundation

struct CurrentAccount {
    private var account: Account
    private(set) var overDraftLimit: Double?

    init(
        bankName: String,
        userId: UUID,
        bankLocation: String,
        minimumBalance: Double = 5000,
        overDraftLimit: Double?
    ) {
        self.overDraftLimit = overDraftLimit
        self.account = Account(
            bankName: bankName,
            userId: userId,
            bankLocation: bankLocation,
            minimumBalance: minimumBalance
        )
    }

    var accountNumber: UUID { account.accountNumber }
    var userId: UUID { account.userId }
    var bankName: String { account.bankName }
    var bankLocation: String { account.bankLocation }
    var openedDate: Date { account.openedDate }
    var minimumBalance: Double { account.minimumBalance }
    var balance: Double { account.balance }

    mutating func withdraw(_ amount: Double) -> Bool {
        guard amount > 0 else { return false }

        let newBalance = balance - amount

        if newBalance >= minimumBalance {
            account.decreaseBalance(amount)
            return true
        }

        if let limit = overDraftLimit, newBalance >= -limit {
            account.decreaseBalance(amount)
            return true
        }
        return false
    }

    mutating func deposit(_ amount: Double) -> Bool {
        guard amount > 0 else { return false }
        account.increaseBalance(amount)
        return true
    }
    
}
