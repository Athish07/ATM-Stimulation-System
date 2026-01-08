import Foundation

struct SavingsAccount {

    private(set) var interestRate: Double
    private var account: Account

    init(
        bankName: String,
        userId: UUID,
        bankLocation: String,
        minimumBalance: Double = 1000,
        interestRate: Double
    ) {
        self.interestRate = interestRate
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
        
        return false
    }
    
//    func calculateInterestOnQuartely() -> Double {
//        ((balance * interestRate) / 365) * 90
//    }

}
