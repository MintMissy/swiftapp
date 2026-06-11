import Foundation

protocol BookingRepositoryProtocol {
    func loadBookings() -> [Booking]
    func saveBookings(_ bookings: [Booking])
}
