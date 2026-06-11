import Foundation

struct Room: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let capacity: Int
    let pricePerNight: Double
    let imageName: String
    let bedType: String
    let isAvailable: Bool
}
