import Foundation

enum TransactionError: String, LocalizedError {
    case accountNotFound
    case depositOperationFailed
    case withdrawOperationFailed
    case sameAccountTransferNotAllowed

    var errorDescription: String {
        switch self {
        case .accountNotFound:
            return "Account not found for the given user."
        case .depositOperationFailed:
            return "Deposit operation failed."
        case .withdrawOperationFailed:
            return "Withdraw operation failed."
        case .sameAccountTransferNotAllowed:
            return "Transaction is not allowed for the same account."
        }
    }
}
