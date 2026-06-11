import Foundation
import Combine

class MainTabViewModel: ObservableObject {
    private let bookingService: BookingService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var selectedTab: Int = 0
    
    init() {
        self.bookingService = ServiceLocator.shared.resolve()
        
        bookingService.$selectedTab
            .assign(to: &$selectedTab)
            
        $selectedTab
            .dropFirst()
            .sink { [weak self] newTab in
                self?.bookingService.selectedTab = newTab
            }
            .store(in: &cancellables)
    }
}
