import Foundation

protocol AccountService {
    
    func createAccount(
            bankName: String,
            userId: UUID,
            bankLocation: String,
            pin: String
        ) -> Account
    
    func deposit(
        to accountNumber: UUID,
        amount: Double
    ) throws

    func withdraw(
        from accountNumber: UUID,
        amount: Double
    ) throws
    
}
