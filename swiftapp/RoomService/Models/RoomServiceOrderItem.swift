import Foundation

struct RoomServiceOrderItem: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let quantity: Int
    let price: Double
}
