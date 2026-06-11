import Foundation

struct Booking: Identifiable, Codable, Hashable {
    let id: UUID
    let hotelId: UUID
    let hotelName: String
    let hotelLocation: String
    let roomName: String
    let checkInDate: Date
    let checkOutDate: Date
    let guestName: String
    let guestEmail: String
    let totalPrice: Double
    let qrCodeData: String
    var status: BookingStatus
    var roomServiceOrders: [RoomServiceOrder] = []
}
