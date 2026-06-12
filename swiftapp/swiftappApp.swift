//
//  swiftappApp.swift
//  swiftapp
//
//  Created by Dawid Kostka on 20/05/2026.
//

import SwiftUI

import SwiftData

@main
struct swiftappApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Booking.self, RoomServiceOrder.self, RoomServiceOrderItem.self)
            let bookingRepository = SwiftDataBookingRepository(modelContext: container.mainContext)
            let bookingService = BookingService(repository: bookingRepository)
            ServiceLocator.shared.register(bookingService)
        } catch {
            fatalError("Failed to initialize SwiftData ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(container)
    }
}
