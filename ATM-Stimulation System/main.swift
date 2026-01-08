import Foundation

let userRepository: UserRepository = InMemoryUserRepository()
let currentAccountRepository: CurrentAccountRepository =
    InMemoryCurrentAccountRepository()
let savingAccountRepository: SavingsAccountRepository =
    InMemorySavingsAccountRepository()
let transactionRepository: TransactionRepository =
    InMemoryTransactionRepository()

let currentAccountService: some AccountTransactionService =  CurrentAccountManager(
    repository: currentAccountRepository
)

let savingAccountService: some AccountTransactionService = SavingsAccountManager(
    repository: savingAccountRepository
)

let authenticationService: AuthenticationService = AuthenticationManager(
    userRepository: userRepository
)

let transactionService: TransactionService = TransactionManager(
    currentService: currentAccountService,
    savingsService: savingAccountService,
    transactionRepository: transactionRepository
)

let userService: UserService = UserManager(userRepository: userRepository)

let appController = AppController(
    authenticationService: authenticationService,
    transactionService: transactionService,
    userService: userService
)
appController.start()
