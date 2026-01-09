import Foundation

struct Account {

    let accountNumber: UUID
    let userId: UUID
    let bankName: String
    let bankLocation: String
    let openedDate: Date
    let pinHash: String
    let minimumBalance: Double

    private(set) var balance: Double

    init(
        bankName: String,
        userId: UUID,
        bankLocation: String,
        minimumBalance: Double,
        pin: String,
        openingBalance: Double = 0
    ) {
        self.accountNumber = UUID()
        self.userId = userId
        self.bankName = bankName
        self.bankLocation = bankLocation
        self.openedDate = Date()
        self.minimumBalance = minimumBalance
        self.pinHash = SecretHasher.hash(pin)
        self.balance = openingBalance
    }
    
    mutating func deposit(_ amount: Double) -> Bool {
        guard amount > 0 else { return false }
        balance += amount
        return true
    }

    mutating func withdraw(
        _ amount: Double,
        allowedNegativeBalance: Double = 0
    ) -> Bool {
        guard amount > 0 else { return false }

        let newBalance = balance - amount
        guard newBalance >= -allowedNegativeBalance else { return false }

        balance = newBalance
        return true
    }
    
    func verifyPin(_ pin: String) -> Bool {
        SecretHasher.verify(pin, against: pinHash)
    }
    
}

