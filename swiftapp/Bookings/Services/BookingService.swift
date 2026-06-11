import Foundation
import Combine

class BookingService: ObservableObject {
    @Published private(set) var bookings: [Booking] = [] {
        didSet {
            repository.saveBookings(bookings)
        }
    }
    
    @Published var selectedTab: Int = 0
    @Published var selectedBookingForDetail: Booking? = nil
    
    private let repository: BookingRepositoryProtocol
    
    init(repository: BookingRepositoryProtocol = UserDefaultsBookingRepository()) {
        self.repository = repository
        self.bookings = repository.loadBookings()
    }
    
    func addBooking(_ booking: Booking) {
        bookings.insert(booking, at: 0)
    }
    
    func addRoomServiceOrder(to bookingId: UUID, order: RoomServiceOrder) {
        if let index = bookings.firstIndex(where: { $0.id == bookingId }) {
            bookings[index].roomServiceOrders.append(order)
        }
    }
}
