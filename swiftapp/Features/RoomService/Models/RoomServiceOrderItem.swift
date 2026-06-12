import Foundation
import SwiftData

@Model
final class RoomServiceOrderItem: Identifiable, Hashable {
    var id: UUID
    var name: String
    var quantity: Int
    var price: Double
    
    init(id: UUID, name: String, quantity: Int, price: Double) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.price = price
    }
}
