import Foundation
import SwiftData

@Model
final class RoomServiceOrder: Identifiable, Hashable {
    var id: UUID
    var timestamp: Date
    
    @Relationship(deleteRule: .cascade)
    var items: [RoomServiceOrderItem]
    
    var totalPrice: Double
    var status: String
    
    init(id: UUID, timestamp: Date, items: [RoomServiceOrderItem], totalPrice: Double, status: String) {
        self.id = id
        self.timestamp = timestamp
        self.items = items
        self.totalPrice = totalPrice
        self.status = status
    }
}
