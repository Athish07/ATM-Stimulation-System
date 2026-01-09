import Foundation

struct InputUtils {

    private static func read(_ prompt: String) -> String {
        
        print(prompt, terminator: ": ")
        let input = readLine()

        return input?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    static func readInt(_ prompt: String, allowCancel: Bool = false) -> Int? {

        while true {

            let input = read(prompt)

            if input.isEmpty, allowCancel {
                return nil
            }

            if let number = Int(input) {
                return number
            }

            print("Invalid Input, please Enter a valid number.")
        }
    }

    static func readString(_ prompt: String, allowCancel: Bool = false) -> String {

        while true {

            let input = read(prompt)

            if input.isEmpty, !allowCancel {
                print("Input cannot be Empty. Enter a valid String.")
                continue
            }

            return input
        }
    }

    static func readEmail(_ prompt: String, allowCancel: Bool = false) -> String {

        while true {

            let email = read(prompt)

            let emailFormat =
                "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailPredicate = NSPredicate(
                format: "SELF MATCHES %@",
                emailFormat
            )

            if (email.isEmpty && allowCancel)
                || !emailPredicate.evaluate(with: email)
            {
                print("Enter a valid email.")
                continue
            }

            return email
        }
    }
    
    static func readPhoneNumber(_ prompt: String, allowCancel: Bool = false) -> String {
          
          while true {
              
              let phoneNumber = read(prompt)
              
              let PHONE_REGEX = "^\\d{10}$"
              let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
              
              if (phoneNumber.isEmpty && allowCancel) || !phoneTest.evaluate(with: phoneNumber) {
                  print("Invalid PhoneNumber formate. Example formate (000-0000-0000)")
                  continue
              }
              
              return phoneNumber
              
          }
      }
    

    static func readPassword(_ prompt: String, allowCancel: Bool = false) -> String {

        while true {

            let password = read(prompt)

            let passwordRegx =
                "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
            let passwordCheck = NSPredicate(
                format: "SELF MATCHES %@",
                passwordRegx
            )

            if (password.isEmpty && allowCancel)
                || !passwordCheck.evaluate(with: password)
            {
                print(
                    """
                    
                    least one uppercase
                    least one digit
                    least one lowercase
                    least one symbol
                    min 8 characters total
                    
                    """
                )
                continue
            }
            
            return password
        }
        
    }
    
    static func readMenuChoice<T>(
        from options: [T],
        prompt: String = "Enter a choice"
    ) -> T? {
        
        guard !options.isEmpty else {
            return nil
        }
        
        while true {
            
            print(prompt, terminator: ": ")
            guard let index = readInt(prompt, allowCancel: false) else {
                return nil
            }
            
            if (1...options.count).contains(index) {
                return options[index - 1]
            }
            
            print("Invalid choice, please try again.")
        }
        
    }
    
}
