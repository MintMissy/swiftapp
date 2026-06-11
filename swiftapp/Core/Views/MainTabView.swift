import SwiftUI

struct MainTabView: View {
    @StateObject private var bookingService = BookingService()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        TabView(selection: $bookingService.selectedTab) {
            ExploreView()
                .tabItem {
                    Label("Eksploruj", systemImage: "magnifyingglass")
                }
                .tag(0)
            
            BookingsView(bookingService: bookingService)
                .tabItem {
                    Label("Rezerwacje", systemImage: "calendar")
                }
                .tag(1)
            
            ProfileView(bookingService: bookingService)
                .tabItem {
                    Label("Profil", systemImage: "person")
                }
                .tag(2)
        }
        .tint(.indigo)
        .environmentObject(bookingService)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    MainTabView()
}
