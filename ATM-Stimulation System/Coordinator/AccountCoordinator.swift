import Foundation

final class AccountCoordinator {

    private let services: [AccountService]
    private let repository: AccountRepository

    init(services: [AccountService]) {
        self.services = services
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
                        $0 is SavingsAccountService
                    })
                    as? SavingsAccountService
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

        guard let service = service(for: accountNumber)
        else { throw AccountError.accountNotFound }

        try service.deposit(
            to: accountNumber,
            pin: pin,
            amount: amount
        )
    }

    func withdraw(
        from accountNumber: UUID,
        pin: String,
        amount: Double
    ) throws {

        guard let service = service(for: accountNumber)
        else { throw AccountError.accountNotFound }

        try service.withdraw(
            from: accountNumber,
            pin: pin,
            amount: amount
        )
    }

    func transfer(
        from source: UUID,
        to destination: UUID,
        pin: String,
        amount: Double
    ) throws {

        try withdraw(from: source, pin: pin, amount: amount)

        do {
            try deposit(to: destination, pin: pin, amount: amount)
        } catch {
            try? deposit(to: source, pin: pin, amount: amount)
            throw error
        }
    }
    
    func getAccounts(for userId: UUID) -> [Account] {
            repository.findByUserId(userId)
    }

    private func service(
        for accountNumber: UUID
    ) -> AccountService? {
        services.first { $0.owns(accountNumber: accountNumber) }
    }

}

