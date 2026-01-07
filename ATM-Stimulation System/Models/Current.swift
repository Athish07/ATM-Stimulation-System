import Foundation

struct Current: Account {
    
    let accountNumber: UUID
    var bankName: String
    let bankLocation: String
    private(set) var amount: Double
    
    init(bankName: String, bankLocation: String) {
        self.accountNumber = UUID()
        self.bankName = bankName
        self.bankLocation = bankLocation
        self.amount = 0.0
        
    }
    
    mutating func updateAmount(amount: Double) -> Bool {
        let finalAmount = self.amount + amount
        
        if finalAmount > 0 {
            self.amount = finalAmount
            return true
        }
        return false
        
    }
    
}


