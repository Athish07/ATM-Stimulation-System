import Foundation

protocol CurrentAccountService {
    func deposit(userId: UUID, amount: Double) throws -> CurrentAccount
    func withdraw(userId: UUID, amount: Double) throws -> CurrentAccount
    func findAccount(userId: UUID) throws -> CurrentAccount
    
}


