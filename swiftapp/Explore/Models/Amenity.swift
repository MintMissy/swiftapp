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
