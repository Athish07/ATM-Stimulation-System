import Foundation

class CurrentAccount: Account {

    let overDraftLimit: Double

    init(
        bankName: String,
        userId: UUID,
        bankLocation: String,
        minimumBalance: Double,
        pin: String,
        overDraftLimit: Double
    ) {
        self.overDraftLimit = overDraftLimit
        super.init(
            bankName: bankName,
            userId: userId,
            bankLocation: bankLocation,
            minimumBalance: minimumBalance,
            pin: pin
        )
    }

    func withdraw(_ amount: Double) -> Bool {
        if amount < 0 {
            return false
        }

        let newBalance = balance - amount

        if newBalance >= 0 {
            decreaseBalance(amount)
            return true
        }
        
        if newBalance >= -overDraftLimit {
            decreaseBalance(amount)
            return true
        }
        return false
    }
    
    func canWithdraw(_ amount: Double) -> Bool {
        
        let newBalance = balance - amount

        if newBalance >= 0 {
            decreaseBalance(amount)
            return true
        }
        
        if newBalance >= -overDraftLimit {
            decreaseBalance(amount)
            return true
        }
        return false
    }
    
}
