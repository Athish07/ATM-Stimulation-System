import Foundation

struct AccountDetails {
    let accountNumber: UUID
    let accountType: AccountType
    let bankName: String
    let bankLocation: String
    let balance: Double
    
    var maskedAccountNumber: String {
        let suffix = accountNumber.uuidString.suffix(4)
        return "XXXX-XXXX-\(suffix)"
    }
}
