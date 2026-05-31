import Foundation

enum Amenity: String, CaseIterable, Identifiable, Codable {
    case wifi
    case pool
    case spa
    case gym
    case parking
    case breakfast
    case petFriendly
    case ac

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .wifi: return "Bezpłatne Wi-Fi"
        case .pool: return "Basen"
        case .spa: return "Strefa SPA"
        case .gym: return "Siłownia"
        case .parking: return "Parking"
        case .breakfast: return "Śniadanie w cenie"
        case .petFriendly: return "Przyjazny zwierzętom"
        case .ac: return "Klimatyzacja"
        }
    }

    var iconName: String {
        switch self {
        case .wifi: return "wifi"
        case .pool: return "figure.pool.swim"
        case .spa: return "sparkles"
        case .gym: return "dumbbell.fill"
        case .parking: return "car.fill"
        case .breakfast: return "fork.knife"
        case .petFriendly: return "pawprint.fill"
        case .ac: return "wind"
        }
    }
}

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

struct RoomServiceOrder: Identifiable, Codable, Hashable {
    let id: UUID
    let timestamp: Date
    let items: [RoomServiceOrderItem]
    let totalPrice: Double
    let status: String
}

struct RoomServiceOrderItem: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let quantity: Int
    let price: Double
}

enum BookingStatus: String, Codable, Hashable {
    case upcoming
    case active
    case past
}

struct Booking: Identifiable, Codable, Hashable {
    let id: UUID
    let hotelId: UUID
    let hotelName: String
    let hotelLocation: String
    let roomName: String
    let checkInDate: Date
    let checkOutDate: Date
    let guestName: String
    let guestEmail: String
    let totalPrice: Double
    let qrCodeData: String
    var status: BookingStatus
    var roomServiceOrders: [RoomServiceOrder] = []
}
