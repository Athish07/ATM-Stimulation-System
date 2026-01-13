import Foundation

final class CurrentAccountManager: AccountService {

    private let repository: AccountRepository
    private let minimumBalance: Double = 5000
    private let overDraftLimit: Double = 5000
    
    init(repository: AccountRepository) {
        self.repository = repository
    }
    
    func createAccount(
        bankName: String,
        userId: UUID,
        bankLocation: String,
        pin: String
    ) -> Account {

        let account = CurrentAccount(
            bankName: bankName,
            userId: userId,
            bankLocation: bankLocation,
            minimumBalance: minimumBalance,
            pin: pin,
            overDraftLimit: overDraftLimit
        )

        accountRepository.save(account)
        return account
    }

    func deposit(
        to accountNumber: UUID,
        amount: Double
    ) throws {
        
        if amount < 0 {
            throw AccountError.invalidAmount
        }
        
        guard
            let account = repository.findByAccountNumber(accountNumber)
                as? CurrentAccount
        else {
            throw AccountError.accountNotFound
        }
        
        account.deposit(amount)
        repository.save(account)
    }
    
    func withdraw(
        from accountNumber: UUID,
        amount: Double
    ) throws {

        if amount < 0 {
            throw AccountError.invalidAmount
        }

        guard
            let account = repository.findByAccountNumber(accountNumber)
                as? CurrentAccount
        else {
            throw AccountError.accountNotFound
        }
        
        guard account.withdraw(amount) else {
            throw AccountError.overdraftLimitExceeded
        }

        repository.save(account)
    }
}

