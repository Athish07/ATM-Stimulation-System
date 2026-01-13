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
    
    static func readDouble(_ prompt: String) -> Double {

        while true {

            let input = read(prompt)

            if let number = Double(input) {
                return number
            }

            print("Invalid Input, please Enter a valid number.")
        }

    }

    static func readEmail(_ prompt: String, allowCancel: Bool = false) -> String
    {

        while true {

            let email = read(prompt)

            let emailFormat =
                "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailPredicate = NSPredicate(
                format: "SELF MATCHES %@",
                emailFormat
            )

            if (email.isEmpty && allowCancel) {
                return email
            }

            if !emailPredicate.evaluate(with: email) {
                print("Enter a valid email.")
                continue
            }

            return email
        }
    }

    static func readPhoneNumber(_ prompt: String, allowCancel: Bool = false)
        -> String
    {

        while true {

            let phoneNumber = read(prompt)

            let PHONE_REGEX = "^\\d{10}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)

            if (phoneNumber.isEmpty && allowCancel) {
                return phoneNumber
            }

            if !phoneTest.evaluate(with: phoneNumber) {
                print("Invalid Phone Number")
                continue
            }

            return phoneNumber

        }
    }

    static func readPassword(
        _ prompt: String,
        allowCancel: Bool = false
    ) -> String {

        while true {

            let password = read(prompt)

            if password.isEmpty && allowCancel {
                return password
            }

            var errors: [String] = []

            if password.count < 8 {
                errors.append("• Minimum 8 characters required")
            }

            if password.range(of: "[A-Z]", options: .regularExpression) == nil {
                errors.append("• At least one uppercase letter required")
            }

            if password.range(of: "[a-z]", options: .regularExpression) == nil {
                errors.append("• At least one lowercase letter required")
            }

            if password.range(of: "[0-9]", options: .regularExpression) == nil {
                errors.append("• At least one digit required")
            }

            if password.range(
                of: "[#?!@$%^&<>*~:`-]",
                options: .regularExpression
            ) == nil {
                errors.append("• At least one special character required")
            }

            if errors.isEmpty {
                return password
            }

            print("\nPassword requirements not met:")
            errors.forEach { print($0) }
        }
    }

    static func readMenuChoice<T>(
        from options: [T],
        prompt: String = "Enter a choice"
    ) -> T? {

        if options.isEmpty {
            return nil
        }

        while true {

            guard let index = readInt(prompt, allowCancel: true) else {
                return nil
            }

            if (1...options.count).contains(index) {
                return options[index - 1]
            }

            print("Invalid choice, please try again.")
        }

    }

    static func readAndVerifyPin(pinHash: String) {

        while true {

            let pin = InputUtils.readString("Enter the pin")

            if pin.isEmpty { return }

            if !SecretHasher.verify(pin, against: pinHash) {
                print("Invalid input, please try again.")
                continue
            }
            return
        }
    }

    static func readAndValidatePin() -> String {
        while true {

            let pin = InputUtils.readString("Enter PIN (4-6 digits)")

            if pin.count < 4 || pin.count > 6 || !pin.allSatisfy(\.isNumber) {
                print("Invalid input, please try again.")
                continue
            }

            let confirm = InputUtils.readString("Confirm PIN")

            if pin == confirm {
                return pin
            }

            print("PINs do not match or invalid format. Try again.")

        }
    }

    static func readPositiveAmount(_ prompt: String) -> Double {

        while true {
            let amount = InputUtils.readDouble(prompt)
            if amount < 0 {
                print("Amount cannot be a negative value, try again.")
                continue
            }
            return amount
        }

    }

}
