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
            case .transactionHistoryByMonthAndYear: transactionHistoryByMonthAndYear()
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

        let pin = InputUtils.readAndValidatePin()
        
        do {
            
            let account = try accountCoordinator.createAccount(
                bankName: bankName,
                userId: userId,
                accountType: accountType,
                bankLocation: bankLocation,
                pin: pin
            )
            
            print("\nAccount Created Successfully.")
            OutputUtils.displayAccountDetails(
                account: account,
                accountType: accountType.rawValue
            )
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    private func deposit() {
        do {

            guard let account = try selectUserAccount() else {
                return
            }
            
            let amount = InputUtils.readPositiveAmount("Enter amount to deposit")
            InputUtils.readAndVerifyPin(pinHash: account.pinHash)
            
            try accountCoordinator.deposit(
                to: account.accountNumber,
                amount: amount
            )

            print(
                "\nDeposit successful! New balance: \(account.balance)"
            )

        } catch {
            print("Deposit failed:", error.localizedDescription)
        }
    }
    
    private func withdraw() {
        do {
            
            guard let account = try selectUserAccount() else {
                return
            }
            
            let amount = InputUtils.readPositiveAmount("Enter amount to withdraw")
            InputUtils.readAndVerifyPin(pinHash: account.pinHash)
            
            try accountCoordinator.withdraw(
                from: account.accountNumber,
                amount: amount
            )
            
            print(
                "\nWithdrawal successful! New balance:\(account.balance)"
            )
        } catch {
            print("Withdrawal failed:", error.localizedDescription)
        }
    }
    
    private func transfer() {
        do {
            
            print("\n---- Money Transfer ----------\n")
            
            guard let source = try selectUserAccount() else {
                return
            }
            
            guard let destination = try selectTransferAccount() else {
                return
            }
            
            if source.accountNumber == destination.accountNumber {
                print("Cannot transfer to the same account.")
                return
            }

            let amount = InputUtils.readPositiveAmount("Enter a amount to transfer")
            InputUtils.readAndVerifyPin(pinHash: source.pinHash)
            
            try accountCoordinator.transfer(
                from: source.accountNumber,
                to: destination.accountNumber,
                amount: amount
            )

            print(
                """
                Transfer successful!
                \(amount) transferred
                New source balance: \(source.balance)
                """
            )
        } catch {
            print("Transfer failed:", error.localizedDescription)
        }
        
    }

    private func viewAccounts() {
        let accounts = accountCoordinator.getUserAccounts(for: userId)

        if accounts.isEmpty {
            print("\nYou don't have any bank accounts yet.\n")
            return
        }

        print("\n=== Your Accounts ===")
        for account in accounts {
            let type = (account is CurrentAccount) ? "Current" : "Savings"
            OutputUtils.displayAccountDetails(
                account: account,
                accountType: type
            )
        }
    }
    
    private func viewProfile() {
        
        guard let user = userService.getUserById(userId) else {
            print("Unable to load the details...")
            return
        }

        print(
            """
            \nName: \(user.name)
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
            "Enter Name(current name: \(user.name))",
            allowCancel: true
        )
        let email = InputUtils.readEmail(
            "Enter Email(current email: \(user.email))",
            allowCancel: true
        )
        let phoneNumber = InputUtils.readPhoneNumber(
            "Enter Phone Number(current phone Number: \(user.phoneNumber))",
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
        
        do {

            guard let account = try selectUserAccount() else {
                return
            }

            let history = accountCoordinator.getTransactionHistory(
                for: account.accountNumber
            )

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
    
    private func transactionHistoryByMonthAndYear() {
        
        do {

            guard let account = try selectUserAccount() else {
                return
            }
            
            let history = accountCoordinator.getTransactionHistory(
                for: account.accountNumber
            )

            if history.isEmpty {
                print("\nNo transactions yet.\n")
                return
            }
            
            let month = InputUtils.readString("Enter the month")
            let year = InputUtils.readInt("Enter the year")
            
            let dateFormatter = DateFormatter()
             dateFormatter.locale = Locale.current
             dateFormatter.dateFormat = "MMMM"
            
            let newHistory = history.filter { history in
                let historyMonthName = dateFormatter.string(from: history.date)
                return historyMonthName.lowercased() == month.lowercased()
                    && Calendar.current.component(.year, from: history.date)
                        == year
            }
            
            if newHistory.isEmpty {
                print("\n No transaction history for that month and year.")
                return
            }
        
            print("\n=== Transaction History Filter By Month and Year ===\n")

            for (index, transaction) in newHistory.enumerated() {
                print("\(index + 1). \(transaction.description())")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension UserController {
    
    private func selectUserAccount() throws -> Account? {
        let accounts = accountCoordinator.getUserAccounts(for: userId)
        
        if accounts.isEmpty {
            throw AccountError.accountNotFound
        }
        
        print("\nYour accounts:")
        for (index, acc) in accounts.enumerated() {
            let last5 = String(acc.accountNumber.uuidString.suffix(5))
            let type = (acc is CurrentAccount) ? "Current" : "Savings"
            print(
                "\(index + 1). \(acc.bankName), AccountNo: XXX-XXX-\(last5) (\(type))"
            )
        }
        
        guard
            let account = InputUtils.readMenuChoice(
                from: accounts,
                prompt: "Enter a choice (press Enter to move back)"
            )
        else {
            return nil
        }
        
        return account
        
    }
    
    private func selectTransferAccount() throws
    -> Account?
    {
        
        let accounts = accountCoordinator.getAllAccounts()
        
        if accounts.isEmpty {
            throw AccountError.accountNotFound
        }
        
        print("\n Select the account to transfer amount:")
        for (index, acc) in accounts.enumerated() {
            
            let last5 = String(acc.accountNumber.uuidString.suffix(5))
            let type = (acc is CurrentAccount) ? "Current" : "Savings"
            
            guard let user = userService.getUserById(acc.userId) else {
                continue
            }
            
            print(
                """
                 \(index + 1). \(acc.bankName), AccountNo: XXX-XXX-\(last5) (\(type))
                     UserName: \(user.name) , PhoneNumber: \(user.phoneNumber)
                
                """
            )
        }
        
        guard
            let account = InputUtils.readMenuChoice(
                from: accounts,
                prompt: "Enter a choice (press Enter to move back)"
            )
        else {
            return nil
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
    case transactionHistoryByMonthAndYear = "Filter the transaction history based on month and year"
    case logout = "Logout"

}
