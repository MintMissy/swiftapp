import Foundation
import Combine
import SwiftUI

class BookingDetailViewModel: ObservableObject {
    let bookingId: UUID
    private let bookingService: BookingService
    
    @Published var isShowingDigitalKey = false
    @Published var isShowingRoomService = false
    
    @Published var booking: Booking
    
    private var cancellables = Set<AnyCancellable>()
    
    init(bookingId: UUID, bookingService: BookingService) {
        self.bookingId = bookingId
        self.bookingService = bookingService
        
        // Find the booking
        if let found = bookingService.bookings.first(where: { $0.id == bookingId }) {
            self.booking = found
        } else {
            self.booking = MockData.bookings[0]
        }
        
        bookingService.$bookings
            .compactMap { $0.first(where: { $0.id == bookingId }) }
            .assign(to: \.booking, on: self)
            .store(in: &cancellables)
    }
    
    var isBookingActiveByDate: Bool {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: booking.checkInDate)
        let end = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: booking.checkOutDate)) ?? booking.checkOutDate
        let now = Date()
        return now >= start && now < end
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "pl_PL")
        return formatter.string(from: date)
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm, dd MMM"
        formatter.locale = Locale(identifier: "pl_PL")
        return formatter.string(from: date)
    }
    
    func openMaps() {
        let address = booking.hotelLocation.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "maps://?q=\(address)") {
            UIApplication.shared.open(url)
        }
    }
}
