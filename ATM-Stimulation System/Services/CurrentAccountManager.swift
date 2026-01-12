import Foundation

final class CurrentAccountManager: AccountService {

    private let repository: AccountRepository
    private let minimumBalance: Double = 5000
    private let overDraftLimit: Double = 5000

    init(repository: AccountRepository) {
        self.repository = repository
    }

    func owns(accountNumber: UUID) -> Bool {
        repository.findByNumber(accountNumber) is CurrentAccount
    }
    
    func createAccount(
        bankName: String,
        userId: UUID,
        bankLocation: String,
        pin: String
    ) -> CurrentAccount {

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
        pin: String,
        amount: Double
    ) throws {

        guard amount > 0 else {
            throw AccountError.invalidAmount
        }

        guard
            let account = repository.findByNumber(accountNumber)
                as? CurrentAccount
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

        guard amount > 0 else {
            throw AccountError.invalidAmount
        }

        guard
            let account = repository.findByNumber(accountNumber)
                as? CurrentAccount
        else {
            throw AccountError.accountNotFound
        }

        try verifyPin(pinHash: account.pinHash, pin: pin)

        guard account.withdraw(amount) else {
            throw AccountError.overdraftLimitExceeded
        }

        repository.save(account)
    }
}
