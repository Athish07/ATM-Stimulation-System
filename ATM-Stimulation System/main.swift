let userRepository: UserRepository = InMemoryUserRepository()
let accountRepository: AccountRepository = InMemoryAccountRepository()
let transactionRepository: TransactionRepository =
    InMemoryTransactionRepository()

let authenticationService: AuthenticationService = AuthenticationManager(
    userRepository: userRepository
)
let savingsAccountService: AccountService =
    SavingsAccountManager(repository: accountRepository)

let currentAccountService: AccountService =
    CurrentAccountManager(repository: accountRepository)

let accountCoordinator: AccountCoordinator =
    AccountManager(
        services: [
            savingsAccountService,
            currentAccountService,
        ],
        accountRepository: accountRepository,
        transactionRepository: transactionRepository
    )

let userService: UserService = UserManager(
    userRepository: userRepository
)

let appController = AppController(
    authenticationService: authenticationService,
    userService: userService,
    accountCoordinator: accountCoordinator
)
appController.start()
