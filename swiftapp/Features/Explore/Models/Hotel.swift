import Foundation

struct Hotel: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let location: String
    let rating: Double
    let reviewCount: Int
    let basePrice: Double
    let imageName: String
    let amenities: [Amenity]
    let rooms: [Room]
}
