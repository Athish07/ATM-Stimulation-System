import Foundation

final class AccountManager: AccountCoordinator {

    private let services: [AccountService]
    private let accountRepository: AccountRepository
    private let transactionRepository: TransactionRepository

    init(services: [AccountService], accountRepository: AccountRepository, transactionRepository: TransactionRepository) {
        self.services = services
        self.accountRepository = accountRepository
        self.transactionRepository = transactionRepository
    }
    
    func createAccount(
        bankName: String,
        userId: UUID,
        accountType: AccountType,
        bankLocation: String,
        pin: String
    ) throws -> Account {
        switch accountType {
        case .current:
            guard
                let currentService =
                    (services.first {
                        $0 is CurrentAccountManager
                    })
                    as? CurrentAccountManager
            else {
                throw AccountError.serviceNotAvailable
            }

            return currentService.createAccount(
                bankName: bankName,
                userId: userId,
                bankLocation: bankLocation,
                pin: pin
            )

        case .savings:
            guard
                let savingsService =
                    (services.first {
                        $0 is SavingsAccountManager
                    })
                    as? SavingsAccountManager
            else {
                throw AccountError.serviceNotAvailable
            }
            return savingsService.createAccount(
                bankName: bankName,
                userId: userId,
                bankLocation: bankLocation,
                pin: pin
            )
        }
    }

    func deposit(
        to accountNumber: UUID,
        pin: String,
        amount: Double
    ) throws {

        guard let service = service(for: accountNumber) else {
            throw AccountError.accountNotFound
        }

        do {
            try service.deposit(to: accountNumber, pin: pin, amount: amount)
            
            recordTransaction(
                accountNumber: accountNumber,
                amount: amount,
                type: .deposit
            )
        } catch {
            
            recordTransaction(
                accountNumber: accountNumber,
                amount: amount,
                type: .deposit,
                status: .failed(reason: error.localizedDescription)
            )
            throw error
        }
    }

    func withdraw(
        from accountNumber: UUID,
        pin: String,
        amount: Double
    ) throws {

        guard let service = service(for: accountNumber) else {
            throw AccountError.accountNotFound
        }
        
        do {
            try service.withdraw(from: accountNumber, pin: pin, amount: amount)
            recordTransaction(
                accountNumber: accountNumber,
                amount: -amount,
                type: .withdrawal
            )
        } catch {
            recordTransaction(
                accountNumber: accountNumber,
                amount: -amount,
                type: .withdrawal,
                status: .failed(reason: error.localizedDescription)
            )
            throw error
        }
    }

    func transfer(
        from source: UUID,
        to destination: UUID,
        pin: String,
        amount: Double
    ) throws {

        do {
            try withdraw(from: source, pin: pin, amount: amount)

            do {
                try deposit(to: destination, pin: pin, amount: amount)
                
                recordTransaction(
                    accountNumber: source,
                    counterAccountNumber: destination,
                    amount: -amount,
                    type: .transfer
                )

                recordTransaction(
                    accountNumber: destination,
                    counterAccountNumber: source,
                    amount: amount,
                    type: .transfer
                )
            } catch {
                try? deposit(to: source, pin: pin, amount: amount)
                throw error
            }
        } catch {
            throw error
        }
    }
    
    func getAccounts(for userId: UUID) -> [Account] {
            accountRepository.findByUserId(userId)
    }
    
    func getTransactionHistory(for accountNumber: UUID) -> [Transaction] {
        transactionRepository.findByAccountNumber(accountNumber)
    }
    
    private func service(
        for accountNumber: UUID
    ) -> AccountService? {
        services.first { $0.owns(accountNumber: accountNumber) }
    }

    private func recordTransaction(
        accountNumber: UUID,
        counterAccountNumber: UUID? = nil,
        amount: Double,
        type: Transaction.TransactionType,
        status: Transaction.TransactionStatus = .completed
    ) {
        let transaction = Transaction(
            accountNumber: accountNumber,
            counterAccountNumber: counterAccountNumber,
            amount: amount,
            type: type,
            status: status
        )
        transactionRepository.save(transaction)
    }
    
}

