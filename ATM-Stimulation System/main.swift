let userRepository: UserRepository = InMemoryUserRepository()
let currentAccountRepository: CurrentAccountRepository = InMemoryCurrentAccountRepository()
let transactionRepository: TransactionRepository =
    InMemoryTransactionRepository()

let authenticationService: AuthenticationService = AuthenticationManager(
    userRepository: userRepository
)
let transactionService: TransactionService = TransactionManager()
let userService: UserService = UserManager()

let appController = AppController(
    authenticationService: authenticationService,
    transactionService: transactionService,
    userService: userService
)
appController.start()
