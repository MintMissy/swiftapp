import Foundation
import Combine

class BookingStore: ObservableObject {
    @Published var bookings: [Booking] = [] {
        didSet {
            saveBookings()
        }
    }
    
    private let saveKey = "saved_bookings"
    
    init() {
        loadBookings()
    }
    
    func addBooking(_ booking: Booking) {
        bookings.insert(booking, at: 0)
    }
    
    func addRoomServiceOrder(to bookingId: UUID, order: RoomServiceOrder) {
        if let index = bookings.firstIndex(where: { $0.id == bookingId }) {
            bookings[index].roomServiceOrders.append(order)
        }
    }
    
    private func saveBookings() {
        if let encoded = try? JSONEncoder().encode(bookings) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadBookings() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Booking].self, from: data) {
            self.bookings = decoded
        } else {
            self.bookings = MockData.bookings
        }
    }
}
