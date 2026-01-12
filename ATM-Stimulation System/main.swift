let userRepository: UserRepository = InMemoryUserRepository()
let accountRepository: AccountRepository = InMemoryAccountRepository()
let transactionRepository: TransactionRepository =
    InMemoryTransactionRepository()

let authenticationService: AuthenticationService = AuthenticationManager(
    userRepository: userRepository
)

let userService: UserService = UserManager()

let appController = AppController(
    authenticationService: authenticationService,
    userService: userService
)
appController.start()
