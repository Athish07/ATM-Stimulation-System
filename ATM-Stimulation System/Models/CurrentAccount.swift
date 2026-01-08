import Foundation

class CurrentAccount: Account {

    private(set) var overDraftLimit: Double?

    init(
        bankName: String,
        userId: UUID,
        bankLocation: String,
        minimumBalance: Double = 5000,
        overDraftLimit: Double?
    ) {
        self.overDraftLimit = overDraftLimit
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
        
        if let limit = overDraftLimit, newBalance >= -limit {
            decreaseBalance(amount)
            return true
        }
        return false
    }

}
