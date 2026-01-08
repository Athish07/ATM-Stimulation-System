import Foundation

protocol SavingsAccountService {
    func deposit(userId: UUID, amount: Double) throws -> SavingsAccount
    func withdraw(userId: UUID, amount: Double) throws -> SavingsAccount
    func findAccount(userId: UUID) throws -> SavingsAccount
    
}



