import Foundation

class SaveingsAccount: Account {

    private(set) var interestRate: Double

    init(
        bankName: String,
        userId: UUID,
        bankLocation: String,
        minimumBalance: Double = 1000,
        interestRate: Double
    ) {
        self.interestRate = interestRate
        super.init(
            bankName: bankName,
            userId: userId,
            bankLocation: bankLocation,
            minimumBalance: minimumBalance
        )
    }
    
    func withdraw(_ amount: Double) -> Bool {
        guard amount > 0 else { return false }
        
        let newBalance = balance - amount
        
        if newBalance >= minimumBalance {
            decreaseBalance(amount)
            return true
        }
        
        return false
    }
    
    func calculateInterestOnQuartely() -> Double {
        ((balance * interestRate) / 365) * 90
    }
    
}
