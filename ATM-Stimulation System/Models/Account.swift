import Foundation

class Account {

    let accountNumber: UUID
    let userId: UUID
    let bankName: String
    let bankLocation: String
    let openedDate: Date
    let minimumBalance: Double
    let pinHash: String

    private(set) var balance: Double = 0.0

    init(
        bankName: String,
        userId: UUID,
        bankLocation: String,
        minimumBalance: Double,
        pin: String
    ) {
        self.accountNumber = UUID()
        self.userId = userId
        self.bankName = bankName
        self.bankLocation = bankLocation
        self.openedDate = Date()
        self.minimumBalance = minimumBalance
        self.pinHash = SecretHasher.hash(pin)
    }
    
    func deposit(_ amount: Double) {
        balance += amount
    }
    
    func decreaseBalance(_ amount: Double) {
        balance -= amount
    }
    
    func maskedNumber() -> String {
        let str = accountNumber.uuidString
        return "XXXX-XXXX-XXXX-" + String(str.suffix(12))
    }
}

public enum AccountType: String, CaseIterable {
    case current = "Current"
    case savings = "Savings"
}

