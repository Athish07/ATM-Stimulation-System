import Foundation

struct SavingsAccount {
    
    private(set) var account: Account

    init(
        bankName: String,
        userId: UUID,
        bankLocation: String,
        pin: String,
        minimumBalance: Double = 2000
    ) {
        self.account = Account(
            bankName: bankName,
            userId: userId,
            bankLocation: bankLocation,
            minimumBalance: minimumBalance,
            pin: pin
        )
    }

    var balance: Double { account.balance }
    var accountNumber: UUID { account.accountNumber }
    var userId: UUID { account.userId }

    mutating func deposit(_ amount: Double) -> Bool {
        account.deposit(amount)
    }

    mutating func withdraw(_ amount: Double) -> Bool {
        account.withdraw(amount)
    }
}

