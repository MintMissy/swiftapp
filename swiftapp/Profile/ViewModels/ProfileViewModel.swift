import Foundation
import Combine
import SwiftUI

class ProfileViewModel: ObservableObject {
    private let bookingService: BookingService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var totalPoints: Int = 2000
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    private let basePoints = 2000
    
    init(bookingService: BookingService) {
        self.bookingService = bookingService
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        
        bookingService.$bookings
            .map { [weak self] bookings in
                (self?.basePoints ?? 2000) + (bookings.count * 1000)
            }
            .assign(to: &$totalPoints)
    }
    
    var statusName: String {
        if totalPoints < 3000 {
            return "Status Brązowy"
        } else if totalPoints < 5000 {
            return "Status Srebrny"
        } else if totalPoints < 8000 {
            return "Status Złoty"
        } else {
            return "Status Platynowy"
        }
    }
    
    var statusColor: Color {
        if totalPoints < 3000 {
            return Color(red: 205/255, green: 127/255, blue: 50/255)
        } else if totalPoints < 5000 {
            return Color(red: 170/255, green: 170/255, blue: 170/255)
        } else if totalPoints < 8000 {
            return Color(red: 212/255, green: 175/255, blue: 55/255)
        } else {
            return Color(red: 160/255, green: 120/255, blue: 220/255)
        }
    }
    
    var targetPoints: Int {
        if totalPoints < 3000 {
            return 3000
        } else if totalPoints < 5000 {
            return 5000
        } else if totalPoints < 8000 {
            return 8000
        } else {
            return 12000
        }
    }
    
    var nextStatusName: String {
        if totalPoints < 3000 {
            return "Srebrnego"
        } else if totalPoints < 5000 {
            return "Złotego"
        } else if totalPoints < 8000 {
            return "Platynowego"
        } else {
            return ""
        }
    }
}
