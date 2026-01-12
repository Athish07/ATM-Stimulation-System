import Foundation

protocol AccountCoordinator {
    
    func createAccount(
        bankName: String,
        userId: UUID,
        accountType: AccountType,
        bankLocation: String,
        pin: String
    ) throws -> Account
    
    func deposit(
        to accountNumber: UUID,
        pin: String,
        amount: Double
    ) throws
    
    func withdraw(
        from accountNumber: UUID,
        pin: String,
        amount: Double
    ) throws
    
    func transfer(
        from source: UUID,
        to destination: UUID,
        pin: String,
        amount: Double
    ) throws
    
    func getAccounts(for userId: UUID) -> [Account]
    
    func getTransactionHistory(for accountNumber: UUID) -> [Transaction]
}
