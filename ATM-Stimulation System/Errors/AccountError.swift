import Foundation

enum AccountError: LocalizedError {
    case accountNotFound
    case invalidAmount
    case insufficientBalance
    case overdraftLimitExceeded
    case serviceNotAvailable
    case noChangeDetected
    
    var errorDescription: String? {
        switch self {
        case .accountNotFound:
            return "Account not found."
        case .invalidAmount:
            return "Invalid amount entered."
        case .insufficientBalance:
            return "Insufficient balance."
        case .overdraftLimitExceeded:
            return "Overdraft limit exceeded."
        case .serviceNotAvailable:
            return "Unexpected error occured."
        case .noChangeDetected:
            return "No change Detected."
        }
    }
}

