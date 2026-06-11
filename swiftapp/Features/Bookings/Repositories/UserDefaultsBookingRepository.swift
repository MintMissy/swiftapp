import Foundation

class UserDefaultsBookingRepository: BookingRepositoryProtocol {
    private let saveKey = "saved_bookings"
    
    func loadBookings() -> [Booking] {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Booking].self, from: data) {
            return decoded
        } else {
            return BookingsMockData.bookings
        }
    }
    
    func saveBookings(_ bookings: [Booking]) {
        if let encoded = try? JSONEncoder().encode(bookings) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}
