import Foundation

final class SavingsAccountManager: AccountService {

    private let repository: AccountRepository
    private let interestRate: Double = 0.85
    private let minimumBalance: Double = 1000
    
    init(repository: AccountRepository) {
        self.repository = repository
    }
    
    func createAccount(
        bankName: String,
        userId: UUID,
        bankLocation: String,
        pin: String
    ) -> Account {

        let account = SavingsAccount(
            bankName: bankName,
            userId: userId,
            bankLocation: bankLocation,
            minimumBalance: minimumBalance,
            pin: pin,
            interestRate: interestRate
        )

        accountRepository.save(account)
        return account
    }

    func deposit(
        to accountNumber: UUID,
        pin: String,
        amount: Double
    ) throws {

        if amount < 0 {
            throw AccountError.invalidAmount
        }

        guard
            let account = repository.findByAccountNumber(accountNumber)
                as? SavingsAccount
        else {
            throw AccountError.accountNotFound
        }

        try verifyPin(pinHash: account.pinHash, pin: pin)

        account.deposit(amount)
        repository.save(account)
    }

    func withdraw(
        from accountNumber: UUID,
        pin: String,
        amount: Double
    ) throws {

        if amount < 0 {
            throw AccountError.invalidAmount
        }
        
        guard
            let account = repository.findByAccountNumber(accountNumber)
                as? SavingsAccount
        else {
            throw AccountError.accountNotFound
        }

        try verifyPin(pinHash: account.pinHash, pin: pin)

        guard account.withdraw(amount) else {
            throw AccountError.insufficientBalance
        }
        
        repository.save(account)
        
    }
    
}
