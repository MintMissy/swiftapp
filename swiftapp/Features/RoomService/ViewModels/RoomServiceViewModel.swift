import Foundation
import Combine

class RoomServiceViewModel: ObservableObject {
    let bookingId: UUID
    let hotelName: String
    let roomName: String
    private let bookingService: BookingService
    
    @Published var selectedCategory = "Jedzenie"
    @Published var quantities: [UUID: Int] = [:]
    
    @Published var state: ViewState<Void> = .idle
    
    let menuItems = RoomServiceMockData.menuItems
    
    init(bookingId: UUID, hotelName: String, roomName: String) {
        self.bookingId = bookingId
        self.hotelName = hotelName
        self.roomName = roomName
        self.bookingService = ServiceLocator.shared.resolve()
    }
    
    var filteredItems: [ServiceItem] {
        menuItems.filter { $0.category == selectedCategory }
    }
    
    var totalCost: Double {
        menuItems.reduce(0.0) { sum, item in
            sum + (item.price * Double(quantities[item.id] ?? 0))
        }
    }
    
    var cartIsEmpty: Bool {
        !quantities.values.contains { $0 > 0 }
    }
    
    var isBookingInactive: Bool {
        if let booking = bookingService.bookings.first(where: { $0.id == bookingId }) {
            return booking.status == .past
        }
        return true
    }
    
    func incrementQuantity(for item: ServiceItem) {
        let current = quantities[item.id] ?? 0
        quantities[item.id] = current + 1
    }
    
    func decrementQuantity(for item: ServiceItem) {
        let current = quantities[item.id] ?? 0
        if current > 0 {
            quantities[item.id] = current - 1
        }
    }
    
    func getQuantity(for item: ServiceItem) -> Int {
        quantities[item.id] ?? 0
    }
    
    func submitOrder() {
        guard !quantities.isEmpty else { return }
        
        state = .loading
        
        // Symulacja API
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            let orderedItems = self.menuItems.compactMap { item -> RoomServiceOrderItem? in
                let qty = self.quantities[item.id] ?? 0
                guard qty > 0 else { return nil }
                return RoomServiceOrderItem(id: UUID(), name: item.name, quantity: qty, price: item.price)
            }
            
            let newOrder = RoomServiceOrder(
                id: UUID(),
                timestamp: Date(),
                items: orderedItems,
                totalPrice: self.totalCost,
                status: "W przygotowaniu"
            )
            
            self.bookingService.addRoomServiceOrder(to: self.bookingId, order: newOrder)
            self.state = .success(())
        }
    }
}
