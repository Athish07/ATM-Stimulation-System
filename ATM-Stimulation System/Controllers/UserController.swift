import Foundation

final class UserController {

    private let userId: UUID
    private let userService: UserService
    private let accountCoordinator: AccountCoordinator

    init(
        userId: UUID,
        userService: UserService,
        accountCoordinator: AccountCoordinator
    ) {
        self.userId = userId
        self.userService = userService
        self.accountCoordinator = accountCoordinator
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
            case .viewAccounts: viewAccounts()
            case .viewProfile: viewProfile()
            case .updateProfile: updateProfile()
            case .transactionHistory: transactionHistory()
            case .logout:
                print("Thanks for useing the application.")
                return
            }

        }
    }

    private func createAccount() {

        print("\n--- Create New Account ---")

        let bankName = InputUtils.readString("Enter bank name")
        let bankLocation = InputUtils.readString("Enter branch/location")

        OutputUtils.showMenu(
            options: AccountType.allCases,
            title: "Select Account Type"
        )
        guard
            let accountType = InputUtils.readMenuChoice(
                from: AccountType.allCases
            )
        else {
            print("Account creation cancelled.")
            return
        }

        let pin = readAndValidatePin()

        do {
            let account = try accountCoordinator.createAccount(
                bankName: bankName,
                userId: userId,
                accountType: accountType,
                bankLocation: bankLocation,
                pin: pin
            )

            print(
                """
                \nAccount created successfully!
                Account Number : \(account.maskedNumber())
                Type           : \(accountType.rawValue)
                Bank           : \(account.bankName)
                Branch         : \(account.bankLocation)
                Opened         : \(account.openedDate)
                Current Balance: \(account.balance)
                """
            )

        } catch {
            print(error.localizedDescription)
        }

    }

    private func deposit() {
        do {
            let account = try selectAccount()
            let amount = try readPositiveAmount("Enter amount to deposit")
            let pin = InputUtils.readString("Enter PIN")

            try accountCoordinator.deposit(
                to: account.accountNumber,
                pin: pin,
                amount: amount
            )

            print(
                "\nDeposit successful! New balance: ₹\(String(format: "%.2f", account.balance))"
            )
        } catch {
            print("Deposit failed:", error.localizedDescription)
        }
    }

    private func withdraw() {
        do {
            let account = try selectAccount()
            let amount = try readPositiveAmount("Enter amount to withdraw")
            let pin = InputUtils.readString("Enter PIN")

            try accountCoordinator.withdraw(
                from: account.accountNumber,
                pin: pin,
                amount: amount
            )

            print(
                "\nWithdrawal successful! New balance: ₹\(String(format: "%.2f", account.balance))"
            )
        } catch {
            print("Withdrawal failed:", error.localizedDescription)
        }
    }
    
    private func transfer() {
        do {
            print("\n---- Money Transfer ----------")

            let source = try selectAccount()
            let destination = try selectAccount()

            if source.accountNumber == destination.accountNumber {
                print("Cannot transfer to the same account.")
                return
            }

            let amount = try readPositiveAmount("Enter a amount to transfer")
            let pin = InputUtils.readString("Enter PIN")

            try accountCoordinator.transfer(
                from: source.accountNumber,
                to: destination.accountNumber,
                pin: pin,
                amount: amount
            )

            print(
                """
                Transfer successful!
                ₹\(String(format: "%.2f", amount)) transferred
                New source balance: ₹\(String(format: "%.2f", source.balance))
                """
            )
        } catch {
            print("Transfer failed:", error.localizedDescription)
        }
    }
    
    private func viewAccounts() {
        let accounts = accountCoordinator.getAccounts(for: userId)

        if accounts.isEmpty {
            print("\nYou don't have any bank accounts yet.\n")
            return
        }

        print("\n=== Your Accounts ===")
        for acc in accounts {
            let type = (acc is CurrentAccount) ? "Current" : "Savings"
            let last4 = String(acc.accountNumber.uuidString.suffix(4))

            print(
                """
                • \(type) Account
                  Bank:     \(acc.bankName)
                  Branch:   \(acc.bankLocation)
                  Number:   ••••\(last4)
                  Balance:  ₹\(String(format: "%.2f", acc.balance))
                  Opened:   \(acc.openedDate.formatted(date: .abbreviated, time: .omitted))
                """
            )
        }
    }
    
    private func viewProfile() {
        
        guard let user = userService.getUserById(userId) else {
            print("Unable to load the details...")
            return
        }
        
        print (
            """
            Name: \(user.name)
            Email: \(user.email)
            PhnoneNumber: \(user.phoneNumber)
            """
        )
    }
    
    private func updateProfile() {
        
        guard let user = userService.getUserById(userId) else {
            print("User not found")
            return
        }

        print("press ENTER if you want to keep the same details:")

        let name = InputUtils.readString(
            "Enter Name(current Name \(user.name))",
            allowCancel: true
        )
        let email = InputUtils.readEmail(
            "Enter Email(current Email \(user.email))",
            allowCancel: true
        )
        let phoneNumber = InputUtils.readPhoneNumber(
            "Enter PhoneNumber(current phoneNumber \(user.phoneNumber))",
            allowCancel: true
        )

        let updatedUser = User(
            id: user.id,
            name: name,
            email: email,
            password: user.passwordHash,
            phoneNumber: phoneNumber
        )

        do {

            try userService.updateProfile(updatedUser)
            print("User updated successfully.")
        } catch {
            print(error.localizedDescription)
        }

    }
    
    private func transactionHistory() {
        print("\n=== Transaction History ===\n")
        
        do {
            let account = try selectAccount()
            
            let history = accountCoordinator.getTransactionHistory(for: account.accountNumber)
            
            if history.isEmpty {
                print("\nNo transactions yet.\n")
                return
            }
            print("\n=== Transaction History ===\n")
            
            for (index, transaction) in history.enumerated() {
                print("\(index + 1). \(transaction.description())")
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension UserController {

    private func readAndValidatePin() -> String {
        while true {
            let pin = InputUtils.readString("Enter PIN (4-6 digits)")
            let confirm = InputUtils.readString("Confirm PIN")

            if pin == confirm, pin.count >= 4, pin.count <= 6,
                pin.allSatisfy(\.isNumber)
            {
                return pin
            }
            print("PINs do not match or invalid format. Try again.")
        }
    }
    
    private func readPositiveAmount(_ prompt: String) throws -> Double {
        let amount = InputUtils.readDouble(prompt)
        guard amount > 0 else { throw AccountError.invalidAmount }
        return amount
    }
    
    private func selectAccount() throws -> Account {
        let accounts = accountCoordinator.getAccounts(for: userId)
        
        if !accounts.isEmpty {
            throw AccountError.accountNotFound
        }
        
        print("\nYour accounts:")
        for (index, acc) in accounts.enumerated() {
            let last4 = String(acc.accountNumber.uuidString.suffix(4))
            let type = (acc is CurrentAccount) ? "Current" : "Savings"
            print(
                "\(index + 1). \(acc.bankName)*****\(last4) (\(type))"
            )
        }
        
        guard let account = InputUtils.readMenuChoice(from: accounts, prompt: "Enter a choice (press Enter to move back)") else {
            throw CancellationError()
        }
        
        return account
        
    }
    
    
    
}

enum UserMenu: String, CaseIterable {
    case viewProfile = "View Profile"
    case updateProfile = "Update Profile"
    case createAccount = "Create New Bank Account"
    case viewAccounts = "View My Accounts"
    case deposit = "Deposit Money"
    case withdraw = "Withdraw Money"
    case transfer = "Transfer Money"
    case transactionHistory = "View Transaction History"
    case logout = "Logout"

}
