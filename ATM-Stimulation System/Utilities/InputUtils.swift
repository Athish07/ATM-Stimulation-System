import Foundation

struct InputUtils {

    private static func read() -> String {

        let input = readLine()

        return input?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    static func readInt(allowCancel: Bool) -> Int? {

        while true {

            let input = read()

            if input.isEmpty, allowCancel {
                return nil
            }

            if let number = Int(input) {
                return number
            }

            print("Invalid Input, please Enter a valid number.")
        }
    }

    static func readString(allowCancel: Bool) -> String {

        while true {

            let input = read()

            if input.isEmpty, !allowCancel {
                print("Input cannot be Empty. Enter a valid String.")
                continue
            }

            return input
        }
    }

    static func readEmail(allowCancel: Bool) -> String {

        while true {

            let email = read()

            let emailFormat =
                "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(
                format: "SELF MATCHES %@",
                emailFormat
            )

            if (email.isEmpty && allowCancel)
                || emailPredicate.evaluate(with: email)
            {
                print("Enter a valid email.")
                continue
            }

            return email
        }
    }
    
    static func phoneNumber(allowCancel: Bool) -> String {
          
          while true {
              
              let phoneNumber = read()
              
              let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
              let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
              
              if (phoneNumber.isEmpty && allowCancel) || phoneTest.evaluate(with: phoneNumber) {
                  print("Invalid PhoneNumber formate. Example formate (000-000-0000)")
                  continue
              }
              
              return phoneNumber
              
          }
      }
    

    static func readPassword(allowCancel: Bool) -> String {

        while true {

            let password = read()

            let passwordRegx =
                "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
            let passwordCheck = NSPredicate(
                format: "SELF MATCHES %@",
                passwordRegx
            )

            if (password.isEmpty && allowCancel)
                || passwordCheck.evaluate(with: password)
            {

                print(
                    """
                    least one uppercase,
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

}
