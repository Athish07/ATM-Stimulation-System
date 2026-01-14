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
            case .viewMiniStatement: viewMiniStatement()
            case .viewProfile: viewProfile()
            case .updateProfile: updateProfile()
            case .updatePassword: updatePassword()
            case .updatePin: updatePin()
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

            guard let account = selectUserAccount() else {
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
            
            guard let account = selectUserAccount() else {
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
            
            guard let source =  selectUserAccount() else {
                return
            }
            
            guard let destination = searchAccounts(source.accountNumber) else {
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
    
    private func viewMiniStatement() {
        
        guard let account = selectUserAccount() else {
            return
        }
        
        let transactionHistory = accountCoordinator.getTransactionHistory(
            for: account.accountNumber
        )
        
        if transactionHistory.isEmpty {
            print("\nNo transactions yet.\n")
            return
        }
        
        var count = 1
        
        for (index,transaction) in transactionHistory.enumerated() {
            
            if count == 5 {
                break
            }
            print("\(index + 1). \(transaction.description())")
            count += 1
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
    
    private func updatePassword() {
        
        guard var user = userService.getUserById(userId) else {
            print("currently unable to update the password")
            return
        }
        
        while true {
            
            let currentPassword = InputUtils.readString("Enter the current password")
            
            if !SecretHasher.verify(currentPassword, against: user.passwordHash) {
                print("Invalid password, try again.")
                continue
            }
            break
        }
        
        let newPassword = InputUtils.readAndValidatePassword("Enter new password")
        userService.updatePassword(newPassword: newPassword, user: &user)
        print("Password updated successfully.")
        
    }
    
    private func updatePin() {
        
        guard let account = selectUserAccount() else {
            return
        }
        
        while true {
            let currentPin = InputUtils.readString("Enter the current PIN")
            
            if !SecretHasher.verify(currentPin, against: account.pinHash) {
                print("Invalid pin, try again")
                continue
            }
            break
        }
        
        let newPin = InputUtils.readAndValidatePin("Enter new PIN (4-6 digits)")
        
        accountCoordinator.updatePin(newPin, account)
        print("PIN updated successfully.")
    }

    private func transactionHistory() {
        
            guard let account = selectUserAccount() else {
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
        
    }
    
    private func transactionHistoryByMonthAndYear() {
        
            guard let account = selectUserAccount() else {
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
    }
}

extension UserController {

    private func selectUserAccount() -> Account? {
        let accounts = accountCoordinator.getUserAccounts(for: userId)

        if accounts.isEmpty {
            print("No account available")
            return nil
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

    private func searchAccounts(_ sourceAccountNumber: UUID) -> Account? {

        print("\nDestination accounts:")
        let searchQuery = InputUtils.readString(
            "Enter the Name of the user to transfer amount or press ENTER to show all the user's",
            allowCancel: true
        ).lowercased()

        let allAccounts = accountCoordinator.getAllAccounts().filter {
            $0.accountNumber != sourceAccountNumber
        }

        if allAccounts.isEmpty {
            print("No accounts available")
            return nil
            
        }

        let filteredAccounts = allAccounts.filter { acc in
            guard let user = userService.getUserById(acc.userId) else {
                return false
            }
            return user.name.lowercased().contains(searchQuery)
        }

        let accountsToDisplay =
            filteredAccounts.isEmpty ? allAccounts : filteredAccounts

        for (index, acc) in accountsToDisplay.enumerated() {

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
                from: accountsToDisplay,
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
    case updatePassword = "Update Password"
    case updatePin = "Update Pin"
    case createAccount = "Create New Bank Account"
    case viewAccounts = "View My Accounts"
    case viewMiniStatement = "View Mini Statement"
    case deposit = "Deposit Money"
    case withdraw = "Withdraw Money"
    case transfer = "Transfer Money"
    case transactionHistory = "View Transaction History"
    case transactionHistoryByMonthAndYear =
        "Filter the transaction history based on month and year"
    case logout = "Logout"
}
