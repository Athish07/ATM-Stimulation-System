import Foundation

struct InputUtils {

    private static func read(_ prompt: String) -> String? {

        print(prompt, terminator: ": ")
        guard
            let input = readLine()?
                .trimmingCharacters(in: .whitespacesAndNewlines),
            !input.isEmpty
        else {
            return nil
        }

        return input
    }

    static func readInt(_ prompt: String, allowCancel: Bool = false) -> Int? {

        while true {

            guard let input = read(prompt) else {
                if allowCancel { return nil }
                print("Invalid Input, please Enter a valid number.")
                continue
            }

            if let number = Int(input) {
                return number
            }

            print("Invalid Input, please Enter a valid number.")
        }
    }

    static func readString(_ prompt: String, allowCancel: Bool = true)
        -> String?
    {

        while true {

            guard let input = read(prompt) else {
                if allowCancel { return nil }
                print("Input cannot be empty.")
                continue
            }

            return input
        }
    }

    static func readDouble(_ prompt: String, allowCancel: Bool = true)
        -> Double?
    {

        while true {

            guard let input = read(prompt) else {
                if allowCancel { return nil }
                print("Invalid Input, please Enter a valid number.")
                continue
            }

            if let number = Double(input) {
                return number
            }

            print("Invalid Input, please Enter a valid number.")
        }

    }

    static func readEmail(_ prompt: String, allowCancel: Bool = true)
        -> String?
    {

        while true {

            let emailFormat =
                "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailPredicate = NSPredicate(
                format: "SELF MATCHES %@",
                emailFormat
            )

            guard let email = read(prompt) else {
                if allowCancel { return nil }
                print("Enter a valid email.")
                continue
            }

            if emailPredicate.evaluate(with: email) {
                return email
            }

            print("Enter a valid email.")
        }
    }

    static func readPhoneNumber(_ prompt: String, allowCancel: Bool = true)
        -> String?
    {

        while true {

            let PHONE_REGEX = "^\\d{10}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)

            guard let phoneNumber = read(prompt) else {
                if allowCancel { return nil }
                print("Enter a valid phone Number.")
                continue
            }

            if phoneTest.evaluate(with: phoneNumber) {
                return phoneNumber
            }

            print("Enter a valid phone Number.")
        }
    }

    static func readPassword(
        _ prompt: String,
        allowCancel: Bool = true
    ) -> String? {

        while true {

            guard let password = read(prompt) else {
                if allowCancel { return nil }
                print("Enter a valid password")
                continue
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
        prompt: String = "Enter a choice",
        allowCancel: Bool = true
    ) -> T? {

        if options.isEmpty {
            return nil
        }

        while true {

            guard let index = readInt(prompt, allowCancel: allowCancel) else {
                return nil
            }

            if (1...options.count).contains(index) {
                return options[index - 1]
            }

            print("Invalid choice, please try again.")
        }

    }

    static func readAndVerifyPin(
        pinHash: String,
        allowCancel: Bool = true
    ) -> Bool {

        while true {

            guard let pin = readPin("Enter the pin (Press Enter to go back)",allowCancel: allowCancel)
            else {
                return !allowCancel
            }

            if SecretHasher.verify(pin, against: pinHash) {
                return true
            }

            print("Invalid PIN, please try again.")
        }
    }

    static func readPin(_ prompt: String, allowCancel: Bool = true) -> String? {

        while true {

            guard let pin = read(prompt) else {
                if allowCancel { return nil }
                print("Invalid input, please try again.")
                continue
            }

            if pin.count < 4 || pin.count > 6 || !pin.allSatisfy(\.isNumber) {
                print("Invalid input, please try again.")
                continue
            }

            return pin
        }
    }

    static func readPositiveAmount(_ prompt: String, allowCancel: Bool = true)
        -> Double?
    {

        while true {

            guard let amount = readDouble(prompt, allowCancel: allowCancel) else {
                if allowCancel { return nil }
                continue
            }
            if amount < 0 {
                print("Amount cannot be a negative value, try again.")
                continue
            }
            return amount
        }

    }

}
