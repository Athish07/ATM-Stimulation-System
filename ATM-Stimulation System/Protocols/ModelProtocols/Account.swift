import Foundation

enum AccountType {
    case Savings
    case Current
    
}

protocol Account {
    var accountNumber: UUID { get }
    var bankName: String { get }
    var bankLocation: String { get }
    var amount: Double { get }
    
}

