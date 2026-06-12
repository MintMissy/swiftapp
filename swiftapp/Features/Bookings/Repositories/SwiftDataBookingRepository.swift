import Foundation
import SwiftData

class SwiftDataBookingRepository: BookingRepositoryProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func loadBookings() -> [Booking] {
        let fetchDescriptor = FetchDescriptor<Booking>(sortBy: [SortDescriptor(\.checkInDate, order: .reverse)])
        do {
            let bookings = try modelContext.fetch(fetchDescriptor)
            if bookings.isEmpty {
                // Seed mock data if empty
                for booking in BookingsMockData.bookings {
                    modelContext.insert(booking)
                }
                try modelContext.save()
                return BookingsMockData.bookings
            }
            return bookings
        } catch {
            print("Failed to fetch bookings: \(error)")
            return []
        }
    }
    
    func saveBookings(_ bookings: [Booking]) {
        // Insert any new bookings that are not yet managed by a context
        for booking in bookings {
            if booking.modelContext == nil {
                modelContext.insert(booking)
            }
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save bookings: \(error)")
        }
    }
}
