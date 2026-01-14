import Foundation

class SavingsAccount: Account {

    let interestRate: Double

    init(
        bankName: String,
        userId: UUID,
        bankLocation: String,
        minimumBalance: Double,
        pin: String,
        interestRate: Double
    ) {
        self.interestRate = interestRate
        super.init(
            bankName: bankName,
            userId: userId,
            bankLocation: bankLocation,
            minimumBalance: minimumBalance,
            pin: pin
        )
    }
    
    func canWithdraw(_ amount: Double) -> Bool {
        return balance - amount >= minimumBalance
    }
    
    func withdraw(_ amount: Double) -> Bool {
        if amount < 0 {
            return false
        }
        
        let newBalance = balance - amount
        
        if newBalance >= minimumBalance {
            decreaseBalance(amount)
            return true
        }
        
        return false
    }
    
}
