import Foundation

class AppController {
    
    private let authenticationService: AuthenticationService
    private let userService: UserService
    private let accountCoordinator: AccountCoordinator
    
    init(
        authenticationService: AuthenticationService,
        userService: UserService,
        accountCoordinator: AccountCoordinator
    ) {
        self.authenticationService = authenticationService
        self.userService = userService
        self.accountCoordinator = accountCoordinator
    }
    
    func start() {
        
        while true {
            
            OutputUtils.showMenu(options: MainMenu.allCases, title: "MainMenu")
            guard
                let choice = InputUtils.readMenuChoice(from: MainMenu.allCases,prompt: "Enter a choice", allowCancel: false)
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
        
        guard let choice = InputUtils.readMenuChoice(from: LoginType.allCases,prompt: "Enter a choice (Press ENTER to go Menu)")
        else {
            return
        }
        
        let identifier: String
        switch choice {
        case .email:
           guard let identifierInput = InputUtils.readString("Enter email (press ENTER to go Menu)") else {
                return
            }
            identifier = identifierInput
        case .phoneNumber:
            guard let identifierInput = InputUtils.readString("Enter phone Number (press ENTER to go Menu)") else {
                return
            }
            identifier = identifierInput
        }
        
        guard let password = InputUtils.readString("Enter password (press Enter to go Menu)") else {
            return
        }
        
        do {
            
            let user = try authenticationService.login(
                type: choice,
                identifier: identifier,
                password: password
            )
            
            print("\nUser login successful, welocome \(user.name)")
            UserController(
                userId: user.id,
                userService: userService,
                accountCoordinator: accountCoordinator
            ).start()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func register() {
        
        print("=== Register New User ===")
        
        guard let name = InputUtils.readString("Enter full name (Press Enter to go Menu)", allowCancel: true) else {
            return
        }
        
        guard let email = InputUtils.readEmail("Enter email (Press Enter to go Menu)", allowCancel: true) else {
            return
        }
        
        guard let password = InputUtils.readPassword("Enter password (Press Enter to go Menu)", allowCancel: true) else {
            return
        }
        
        guard let phoneNumber = InputUtils.readPhoneNumber("Enter phone number (Press ENTER to go Menu)", allowCancel: true) else {
            return
        }
        
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
