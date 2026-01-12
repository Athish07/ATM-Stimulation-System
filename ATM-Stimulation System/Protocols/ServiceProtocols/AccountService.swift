import Foundation

protocol AccountService {
    func deposit(
        to accountNumber: UUID,
        pin: String,
        amount: Double
    ) throws

    func withdraw(
        from accountNumber: UUID,
        pin: String,
        amount: Double
    ) throws

    func owns(accountNumber: UUID) -> Bool
}

extension AccountService {
    
    func verifyPin(pinHash: String, pin: String) throws {
        if !SecretHasher.verify(pin, against: pinHash) {
            throw AccountError.incorrectPin
        }
    }
}

enum AccountError: LocalizedError {
    case accountNotFound
    case invalidAmount
    case incorrectPin
    case insufficientBalance
    case overdraftLimitExceeded
    case serviceNotAvailable
    
    var errorDescription: String? {
        switch self {
        case .accountNotFound:
            return "Account not found."
        case .invalidAmount:
            return "Invalid amount entered."
        case .incorrectPin:
            return "Incorrect PIN."
        case .insufficientBalance:
            return "Insufficient balance."
        case .overdraftLimitExceeded:
            return "Overdraft limit exceeded."
        case .serviceNotAvailable:
            return "Unexpected error occured."
        }
    }
}
