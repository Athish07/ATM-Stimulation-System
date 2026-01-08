import Foundation

class UserController {

    private let userId: UUID
    private let userService: UserService
    private let transactionService: TransactionService

    init(
        userId: UUID,
        userService: UserService,
        transactionService: TransactionService
    ) {
        self.userId = userId
        self.userService = userService
        self.transactionService = transactionService
    }
    
    
}

extension UserController {

    enum UserMenu: String, CustomStringConvertible {
        case createAccount = "Create New Bank Account"
        case viewAccounts = "View My Accounts"
        case deposit = "Deposit Money"
        case withdraw = "Withdraw Money"
        case transfer = "Transfer Money"
        case transactionHistory = "View Transaction History"
        case logout = "Logout"

        var description: String { rawValue }
    }

}
