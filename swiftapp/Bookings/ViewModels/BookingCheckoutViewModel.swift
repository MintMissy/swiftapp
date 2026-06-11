import Foundation
import Combine

class BookingCheckoutViewModel: ObservableObject {
    let hotel: Hotel
    let room: Room
    private let bookingService: BookingService
    
    @Published var checkInDate = Date()
    @Published var checkOutDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @Published var guestName = "Jan Kowalski"
    @Published var guestEmail = "jan.kowalski@student.wsb.poznan.pl"
    
    @Published var isLoading = false
    @Published var isSuccess = false
    
    init(hotel: Hotel, room: Room, bookingService: BookingService) {
        self.hotel = hotel
        self.room = room
        self.bookingService = bookingService
    }
    
    var numberOfNights: Int {
        let calendar = Calendar.current
        let fromDate = calendar.startOfDay(for: checkInDate)
        let toDate = calendar.startOfDay(for: checkOutDate)
        let components = calendar.dateComponents([.day], from: fromDate, to: toDate)
        return max(1, components.day ?? 1)
    }
    
    var basePrice: Double {
        room.pricePerNight * Double(numberOfNights)
    }
    
    var vatPrice: Double {
        basePrice * 0.08
    }
    
    var totalPrice: Double {
        basePrice + vatPrice
    }
    
    var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: guestEmail)
    }
    
    var isFormValid: Bool {
        !guestName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && isEmailValid
    }
    
    func onCheckInDateChange(newCheckIn: Date) {
        if checkOutDate <= newCheckIn {
            checkOutDate = Calendar.current.date(byAdding: .day, value: 1, to: newCheckIn) ?? newCheckIn
        }
    }
    
    func startPayment() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading = false
            self?.isSuccess = true
        }
    }
    
    func completeBooking(onComplete: @escaping () -> Void) {
        let code = "RES-\(hotel.name.prefix(2).uppercased())-\(Int.random(in: 1000...9999))"
        let booking = Booking(
            id: UUID(),
            hotelId: hotel.id,
            hotelName: hotel.name,
            hotelLocation: hotel.location,
            roomName: room.name,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            guestName: guestName,
            guestEmail: guestEmail,
            totalPrice: totalPrice,
            qrCodeData: code,
            status: .upcoming
        )
        bookingService.addBooking(booking)
        onComplete()
        bookingService.selectedTab = 1
        bookingService.selectedBookingForDetail = booking
    }
}
