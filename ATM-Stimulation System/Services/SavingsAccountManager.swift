import Foundation

final class SavingsAccountManager: AccountService {

    private let repository: AccountRepository
    private let transactionRepository: TransactionRepository
    private let interestRate: Double = 0.85
    private let minimumBalance: Double = 10
    
    private let perDayLimit: Double = 1000
    private let perMonthLimit: Double = 10_000
    private let perYearLimit: Double = 1_00_000
    
    init(repository: AccountRepository, transactionRepository: TransactionRepository) {
        self.repository = repository
        self.transactionRepository = transactionRepository
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
                as? SavingsAccount
        else {
            throw AccountError.accountNotFound
        }
        
        try validateTransactionLimit(accountNumber: accountNumber, amount: amount)
        
        guard account.withdraw(amount) else {
            throw AccountError.insufficientBalance
        }
        
        repository.save(account)
        
    }
    
}

extension SavingsAccountManager {
    
    private func validateTransactionLimit(accountNumber: UUID, amount: Double) throws {
        
        let history = accountCoordinator.getTransactionHistory(
            for: accountNumber
        )
        
        if amount > perDayLimit {
            throw TransactionLimitError.perDayLimitExceed
        }
        
        if history.isEmpty { return }
        
        let calendar = Calendar.current
        
        let todayStart = calendar.startOfDay(for: Date())
        let monthAsInt = calendar.component(.month, from: todayStart)
        let yearAsInt = calendar.component(.year, from: todayStart)
        
        guard let tomorrowStart = calendar.date(byAdding: .day, value: 1, to: todayStart) else {
            fatalError("Could not calculate tomorrow's date")
        }
        
        let perDayHistory = history.filter { history in
            return history.date >= todayStart && history.date < tomorrowStart
        }
        
        let perMonthHistory = history.filter { history in
            return calendar.component(.month, from: history.date) == monthAsInt &&
            calendar.component(.year, from: history.date) == yearAsInt
        }
        
        let perYearHistory = history.filter { history in
            return calendar.component(.year, from: history.date) == yearAsInt
        }
        
        var perDaySum: Double = 0
        var perMonthSum: Double = 0
        var perYearSum: Double = 0
        
        sumAmount(amountSum: &perDaySum, transactionHistory: perDayHistory)
        sumAmount(amountSum: &perMonthSum, transactionHistory: perMonthHistory)
        sumAmount(amountSum: &perYearSum, transactionHistory: perYearHistory)
        
        if perDaySum + amount > perDayLimit {
            throw TransactionLimitError.perDayLimitExceed
        }
        
        if perMonthSum + amount > perMonthLimit {
            throw TransactionLimitError.perMonthLimitExceed
        }
        
        if perYearSum + amount > perYearLimit {
            throw TransactionLimitError.perYearLimitExceed
        }
    }
    
    private func sumAmount(amountSum: inout Double, transactionHistory: [Transaction]) {
        
        for history in transactionHistory {
            
            if history.type == .withdrawal && history.status == .completed {
                amountSum += abs(history.amount)
            }
        }
    }
}

enum TransactionLimitError: LocalizedError {
    case perDayLimitExceed
    case perMonthLimitExceed
    case perYearLimitExceed
    
    var errorDescription: String? {
        
        switch self {
        case .perDayLimitExceed: return "Cannot proceed with the transaction amount is more than per day limit."
        case .perMonthLimitExceed: return "Cannot proceed with the transaction amount is more than per month limit."
        case .perYearLimitExceed: return "Cannot proceed with the transaction amount is more than per year limit."
        }
        
    }
}
