import Foundation

let userRepository: UserRepository = InMemoryUserRepository()
let currentAccountRepository: CurrentAccountRepository =
    InMemoryCurrentAccountRepository()
let savingAccountRepository: SavingsAccountRepository =
    InMemorySavingsAccountRepository()
let transactionRepository: TransactionRepository =
    InMemoryTransactionRepository()

let authenticationService: AuthenticationService = AuthenticationManager(
    userRepository: userRepository
)
let userService: UserService = UserManager(userRepository: userRepository)

let accountService: AccountService = AccountManager(
    currentAccountRepository: currentAccountRepository,
    savingsAccountRepository: savingAccountRepository,
    transactionRepository: transactionRepository
)

let appController = AppController(
    authenticationService: authenticationService,
    userService: userService,
    accountService: accountService
)
appController.start()
