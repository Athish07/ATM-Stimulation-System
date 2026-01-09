import CryptoKit
import Foundation

struct SecretHasher {

    static func hash(_ value: String) -> String {
        let data = Data(value.utf8)
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    static func verify(_ value: String, against hash: String) -> Bool {
        self.hash(value) == hash
    }
}
