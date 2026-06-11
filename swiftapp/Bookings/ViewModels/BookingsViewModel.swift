import Foundation
import Combine

class BookingsViewModel: ObservableObject {
    @Published var selectedTab: BookingStatus = .upcoming
    @Published var filteredBookings: [Booking] = []
    @Published var selectedBookingForDetail: Booking? = nil
    
    private let bookingService: BookingService
    private var cancellables = Set<AnyCancellable>()
    
    init(bookingService: BookingService) {
        self.bookingService = bookingService
        
        Publishers.CombineLatest($selectedTab, bookingService.$bookings)
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
