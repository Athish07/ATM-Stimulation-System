import Foundation

struct DatabaseSeeder {
    
    static func seedDemoUserWithSavingsAccount(
            userRepository: UserRepository,
            accountCoordinator: AccountCoordinator
    ) {
        
        let user = User(
            name: "User",
            email: "athish@gmail.com",
            password: "Athish@07",
            phoneNumber: "9841577186"
        )
        
        userRepository.save(user)
        
       _ = try? accountCoordinator.createAccount(
            bankName: "Swift Bank",
            userId: user.id,
            accountType: .savings,
            bankLocation: "Chennai",
            pin: "1111"
        )
        
        
    }

}
