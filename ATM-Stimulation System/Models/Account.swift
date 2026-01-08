import Foundation

class Account {

    let accountNumber: UUID
    let userId: UUID
    let bankName: String
    let bankLocation: String
    let openedDate: Date
    let minimumBalance: Double

    private(set) var balance: Double = 0.0

    init(
        bankName: String,
        userId: UUID,
        bankLocation: String,
        minimumBalance: Double,
    ) {
        self.accountNumber = UUID()
        self.userId = userId
        self.bankName = bankName
        self.bankLocation = bankLocation
        self.openedDate = Date()
        self.minimumBalance = minimumBalance
    }
    
    func deposit(_ amount: Double) -> Bool {
        guard amount > 0 else { return false }
        balance += amount
        return true
    }
    
    func increaseBalance(_ amount: Double) {
        balance += amount
    }
    
    func decreaseBalance(_ amount: Double) {
        balance -= amount
    }
    
    
}

