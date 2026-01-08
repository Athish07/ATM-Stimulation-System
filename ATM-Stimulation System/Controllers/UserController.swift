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
