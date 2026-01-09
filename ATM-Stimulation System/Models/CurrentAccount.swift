import Foundation

struct CurrentAccount {
    
    private(set) var account: Account
    let overdraftLimit: Double

    init(
        bankName: String,
        userId: UUID,
        bankLocation: String,
        minimumBalance: Double = 5000,
        pin: String,
        overdraftLimit: Double
    ) {
        self.overdraftLimit = overdraftLimit
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
        account.withdraw(
            amount,
            allowedNegativeBalance: overdraftLimit
        )
    }
}

