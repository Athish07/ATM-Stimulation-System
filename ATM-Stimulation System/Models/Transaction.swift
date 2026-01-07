import Foundation

struct Transaction {
    
    let id: UUID
    let senderAccoutNumber: UUID
    let receiverAccountNumber: UUID
    let date: Date
    
    init(senderAccoutNumber: UUID, receiverAccountNumber: UUID) {
        self.id = UUID()
        self.senderAccoutNumber = senderAccoutNumber
        self.receiverAccountNumber = receiverAccountNumber
        self.date = Date()
    }
    
}
