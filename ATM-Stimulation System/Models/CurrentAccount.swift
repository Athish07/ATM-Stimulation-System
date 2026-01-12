import Foundation

class CurrentAccount: Account {

    private(set) var overDraftLimit: Double

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

        if newBalance >= minimumBalance {
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
