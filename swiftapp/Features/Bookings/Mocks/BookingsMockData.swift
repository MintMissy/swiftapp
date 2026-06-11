import Foundation

struct BookingsMockData {
    static let bookings: [Booking] = [
        Booking(
            id: UUID(uuidString: "99999999-9999-9999-9999-999999999999")!,
            hotelId: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
            hotelName: "Grand Poznań Hotel & Spa",
            hotelLocation: "Poznań, Stare Miasto",
            roomName: "Pokój Standard Double",
            checkInDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
            checkOutDate: Calendar.current.date(byAdding: .day, value: 8, to: Date())!,
            guestName: "Jan Kowalski",
            guestEmail: "jan.kowalski@student.wsb.poznan.pl",
            totalPrice: 1050.0,
            qrCodeData: "RESERVE-GP-9999-KOWALSKI",
            status: .upcoming
        ),
        Booking(
            id: UUID(uuidString: "88888888-8888-8888-8888-888888888888")!,
            hotelId: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
            hotelName: "Baltic Wave Sopot Resort",
            hotelLocation: "Sopot, Nadmorska",
            roomName: "Pokój Superior z Widokiem na Morze",
            checkInDate: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
            checkOutDate: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
            guestName: "Jan Kowalski",
            guestEmail: "jan.kowalski@student.wsb.poznan.pl",
            totalPrice: 1800.0,
            qrCodeData: "RESERVE-BW-8888-KOWALSKI",
            status: .past
        )
    ]
}
