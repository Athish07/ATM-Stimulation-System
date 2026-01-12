struct OutputUtils {
    
    static func showMenu<T: RawRepresentable>(
        options: [T],
        title: String
    ) {
        
        print("\n==== \(title) =====\n")
        
        for (index,option) in options.enumerated() {
            
            print("\(index + 1). \(option)")
        }
    }
    
    static func displayAccountDetails(account: Account, accountType: String) {
        
        print(
            """
            Account Number : \(account.maskedNumber())
            Type           : \(accountType)
            Bank           : \(account.bankName)
            Branch         : \(account.bankLocation)
            Opened         : \(account.openedDate.formatted)
            Current Balance: \(account.balance)
            """
        )
    }
    
}
 
