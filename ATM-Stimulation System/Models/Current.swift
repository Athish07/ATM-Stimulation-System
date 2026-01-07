import Foundation

struct Current: Account {
    
    let accountNumber: UUID
    var bankName: String
    let bankLocation: String
    
    init(accountNumber: UUID, bankName: String, bankLocation: String) {
        self.accountNumber = accountNumber
        self.bankName = bankName
        self.bankLocation = bankLocation
    }
    
}
