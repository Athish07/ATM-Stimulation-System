import Foundation

class AppController {

    private let authenticationService: AuthenticationService
    private let transactionService: TransactionService
    private let userService: UserService

    init(
        authenticationService: AuthenticationService,
        transactionService: TransactionService,
        userService: UserService
    ) {
        self.authenticationService = authenticationService
        self.transactionService = transactionService
        self.userService = userService
    }

    func start() {

        while true {

            OutputUtils.showMenu(options: MainMenu.allCases, title: "MainMmenu")
            guard
                let choice = InputUtils.readMenuChoice(from: MainMenu.allCases)
            else {
                print("Invalid choice, try again.")
                continue
            }

            switch choice {

            case .login: login()
            case .register: register()
            case .exit:
                print("Thanks for using the application ")
                exit(0)
            }

        }
    }

    private func login() {

        OutputUtils.showMenu(
            options: LoginType.allCases,
            title: "Login Options"
        )

        guard let choice = InputUtils.readMenuChoice(from: LoginType.allCases)
        else {
            return
        }

        let identifier: String

        switch choice {
        case .email:
            identifier = InputUtils.readString("Enter email")
        case .phoneNumber:
            identifier = InputUtils.readString("Enter phoneNumber")
        }
        let password = InputUtils.readString("Enter password")

        do {

            let user = try authenticationService.login(
                type: choice,
                identifier: identifier,
                password: password
            )
            print("\nUser login successful, welocome \(user.name)")
            
        } catch {
            print(error.localizedDescription)
        }
        
    }

    private func register() {

        print("=== Register New User ===")

        let name = InputUtils.readString("Enter full name")
        let email = InputUtils.readEmail("Enter email")
        let password = InputUtils.readPassword("Enter password")
        let confirm = InputUtils.readPassword("Confirm password")

        guard password == confirm else {
            print("Passwords dosen't match.")
            return
        }
        let phoneNumber = InputUtils.readPhoneNumber("Enter phone number")

        do {

            try authenticationService.register(
                name: name,
                email: email,
                password: password,
                phoneNumber: phoneNumber
            )
            print("\nUser registered successfully.")
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

extension AppController {

    enum MainMenu: String, CaseIterable {
        case login = "Login"
        case register = "Registration"
        case exit = "Exit application"
    }

}
