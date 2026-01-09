import Foundation

final class ReportManager {

    private let transactionRepository: TransactionRepository

    init(transactionRepository: TransactionRepository) {
        self.transactionRepository = transactionRepository
    }
    
    func transacionHistory(accountNumber: UUID) -> [Transaction] {
        transactionRepository.findByAccountNumber(accountNumber)
    }
    
}
