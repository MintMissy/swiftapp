import Foundation
import Combine

class BookingsViewModel: ObservableObject {
    @Published var selectedTab: BookingStatus = .upcoming
    @Published var filteredBookings: [Booking] = []
    @Published var selectedBookingForDetail: Booking? = nil
    
    private let bookingStore: BookingStore
    private var cancellables = Set<AnyCancellable>()
    
    init(bookingStore: BookingStore) {
        self.bookingStore = bookingStore
        
        Publishers.CombineLatest($selectedTab, bookingStore.$bookings)
            .map { tab, bookings in
                let filtered = bookings.filter { $0.status == tab }
                if tab == .upcoming {
                    return filtered.sorted { $0.checkInDate < $1.checkInDate }
                } else {
                    return filtered.sorted { $0.checkInDate > $1.checkInDate }
                }
            }
            .assign(to: &$filteredBookings)
    }
}
