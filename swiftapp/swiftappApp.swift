//
//  swiftappApp.swift
//  swiftapp
//
//  Created by Dawid Kostka on 20/05/2026.
//

import SwiftUI

@main
struct swiftappApp: App {
    init() {
        let bookingRepository = UserDefaultsBookingRepository()
        let bookingService = BookingService(repository: bookingRepository)
        ServiceLocator.shared.register(bookingService)
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
