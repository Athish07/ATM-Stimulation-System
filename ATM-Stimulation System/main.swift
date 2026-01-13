let userRepository: UserRepository = InMemoryUserRepository()
let accountRepository: AccountRepository = InMemoryAccountRepository()
let transactionRepository: TransactionRepository =
    InMemoryTransactionRepository()

let authenticationService: AuthenticationService = AuthenticationManager(
    userRepository: userRepository
)
let savingsAccountService =
    SavingsAccountManager(repository: accountRepository)

let currentAccountService =
    CurrentAccountManager(repository: accountRepository)

let accountCoordinator: AccountCoordinator =
    AccountManager(
        accountRepository: accountRepository,
        transactionRepository: transactionRepository,
        currentAccountService: currentAccountService,
        savingsAccountService: savingsAccountService
    )

let userService: UserService = UserManager(
    userRepository: userRepository
)

DatabaseSeeder.seedDemoUserWithSavingsAccount(
    userRepository: userRepository,
    accountCoordinator: accountCoordinator
)

let appController = AppController(
    authenticationService: authenticationService,
    userService: userService,
    accountCoordinator: accountCoordinator
)
appController.start()
