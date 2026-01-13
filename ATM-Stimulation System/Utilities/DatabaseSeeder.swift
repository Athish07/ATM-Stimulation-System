import Foundation

struct DatabaseSeeder {
    
    static func seedDemoUserWithSavingsAccount(
            userRepository: UserRepository,
            accountCoordinator: AccountCoordinator
    ) {
        
        let users: [User] = [
            
            User(
                name: "Abishek T",
                email: "2@1.com",
                password: "Athish@07",
                phoneNumber: "1234567880"
            ),
            
            User(
                name: "Jeeva",
                email: "1@1.com",
                password: "Athish@07",
                phoneNumber: "1234567890"
            ),
            
            User(
                name: "User",
                email: "athish@gmail.com",
                password: "Athish@07",
                phoneNumber: "9841577186"
            )
        ]
        
        for user in users {
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

}
