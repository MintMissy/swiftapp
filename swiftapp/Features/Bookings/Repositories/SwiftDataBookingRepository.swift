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
        // SwiftData automatically saves changes when modelContext.save() is called.
        // We only need to call save() explicitly if we want to force a write.
        do {
            try modelContext.save()
        } catch {
            print("Failed to save bookings: \(error)")
        }
    }
}
