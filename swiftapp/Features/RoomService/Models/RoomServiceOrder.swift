import Foundation

struct RoomServiceOrder: Identifiable, Codable, Hashable {
    let id: UUID
    let timestamp: Date
    let items: [RoomServiceOrderItem]
    let totalPrice: Double
    let status: String
}
