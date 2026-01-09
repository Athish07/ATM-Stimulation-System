import Foundation

protocol AccountService {

    func createAccount(
        userId: UUID,
        type: AccountType,
        bankName: String,
        bankLocation: String,
        pin: String
    ) -> AccountDetails
    
    func deposit(
        to accountNumber: UUID,
        amount: Double
    ) -> Bool
    
    func withdraw(
        from accountNumber: UUID,
        amount: Double
    ) -> Bool
    
    func transfer(
        from sourceAccount: UUID,
        to destinationAccount: UUID,
        amount: Double
    )
    
}

enum AccountType: String, CaseIterable {
    case current = "Current Account"
    case savings = "Savings Account" 
}
