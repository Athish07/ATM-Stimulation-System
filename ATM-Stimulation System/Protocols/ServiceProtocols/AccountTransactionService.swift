import Foundation

protocol AccountTransactionService {
    associatedtype AccountType: Account
    
    func deposit(userId: UUID, amount: Double) throws -> AccountType
    func withdraw(userId: UUID, amount: Double) throws -> AccountType
    func findAccount(userId: UUID) throws -> AccountType
}

