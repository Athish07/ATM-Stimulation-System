import Foundation

protocol AccountCoordinator {
    
    func createAccount(
        bankName: String,
        userId: UUID,
        accountType: AccountType,
        bankLocation: String,
        pin: String
    ) throws -> Account
    
    func validateWithdrawal(
        for accountNumber: UUID,
        amount: Double
    ) throws
    
    func deposit(
        to accountNumber: UUID,
        amount: Double
    ) throws
    
    func withdraw(
        from accountNumber: UUID,
        amount: Double
    ) throws
    
    func transfer(
        from source: UUID,
        to destination: UUID,
        amount: Double
    ) throws
    
    func getUserAccounts(for userId: UUID) -> [Account]
    func getAllAccounts() -> [Account]
    func updatePin(_ newPin: String, _ account: Account)
    
    func getTransactionHistory(for accountNumber: UUID) -> [Transaction]
}

