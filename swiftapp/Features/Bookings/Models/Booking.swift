import Foundation
import SwiftData

@Model
final class Booking: Identifiable, Hashable {
    var id: UUID
    var hotelId: UUID
    var hotelName: String
    var hotelLocation: String
    var roomName: String
    var checkInDate: Date
    var checkOutDate: Date
    var guestName: String
    var guestEmail: String
    var totalPrice: Double
    var qrCodeData: String
    var status: BookingStatus
    
    @Relationship(deleteRule: .cascade)
    var roomServiceOrders: [RoomServiceOrder]
    
    init(id: UUID, hotelId: UUID, hotelName: String, hotelLocation: String, roomName: String, checkInDate: Date, checkOutDate: Date, guestName: String, guestEmail: String, totalPrice: Double, qrCodeData: String, status: BookingStatus, roomServiceOrders: [RoomServiceOrder] = []) {
        self.id = id
        self.hotelId = hotelId
        self.hotelName = hotelName
        self.hotelLocation = hotelLocation
        self.roomName = roomName
        self.checkInDate = checkInDate
        self.checkOutDate = checkOutDate
        self.guestName = guestName
        self.guestEmail = guestEmail
        self.totalPrice = totalPrice
        self.qrCodeData = qrCodeData
        self.status = status
        self.roomServiceOrders = roomServiceOrders
    }
}
