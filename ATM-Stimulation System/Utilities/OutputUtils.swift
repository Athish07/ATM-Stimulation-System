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
    
}
 
