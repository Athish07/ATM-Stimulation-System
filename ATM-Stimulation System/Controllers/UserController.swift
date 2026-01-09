import Foundation

class UserController {

    private let userId: UUID
    private let userService: UserService
    private let accountService: AccountService

    init(
        userId: UUID,
        userService: UserService,
        accountService: AccountService
    ) {
        self.userId = userId
        self.userService = userService
        self.accountService = accountService
    }

    func start() {

        while true {
            OutputUtils.showMenu(options: UserMenu.allCases, title: "UserMenu")

            guard
                let choice = InputUtils.readMenuChoice(from: UserMenu.allCases)
            else {
                print("Invalid Choice.")
                continue
            }

            switch choice {
            case .createAccount: createAccount()
            case .deposit: deposit()
            case .withdraw: withdraw()
            case .transfer: transfer()
            case .viewProfile: viewProfile()
            case .updateProfile: updateProfile()
            case .transactionHistory: transactionHistory()
            case .logout: return
            }

        }
    }

    private func createAccount() {

        let bankName = InputUtils.readString("Enter the bank name ")
        let bankLocation = InputUtils.readString("Enter the bank location ")
        OutputUtils.showMenu(
            options: AccountType.allCases,
            title: "Account Type"
        )
        guard let accountType = InputUtils.readMenuChoice(from: AccountType.allCases) else {
            return
        }
        
       let accountDetails =  accountService.createAccount(
            userId: userId,
            type: accountType,
            bankName: bankName,
            bankLocation: bankLocation
        )
        
        print("Account has been created successfully.")
        print(
            """
            AccountNo: \(accountDetails.maskedAccountNumber)
            AccountType: \(accountDetails.accountType.rawValue)
            BankName: \(accountDetails.bankName)
            BankLocation: \(accountDetails.bankLocation)
            Balance: \(accountDetails.balance)
            """
        )
        
    }

    private func deposit() {

    }

    private func withdraw() {

    }

    private func transfer() {

    }

    private func viewProfile() {

    }
    private func updateProfile() {

    }
    private func transactionHistory() {

    }

}

extension UserController {

    enum UserMenu: String, CaseIterable {
        case viewProfile = "View Profile"
        case updateProfile = "Update Profile"
        case createAccount = "Create New Bank Account"
        //        case viewAccounts = "View My Accounts"
        case deposit = "Deposit Money"
        case withdraw = "Withdraw Money"
        case transfer = "Transfer Money"
        case transactionHistory = "View Transaction History"
        case logout = "Logout"

    }

}
