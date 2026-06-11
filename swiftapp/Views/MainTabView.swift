import SwiftUI

struct MainTabView: View {
    @StateObject private var bookingStore = BookingStore()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        TabView(selection: $bookingStore.selectedTab) {
            ExploreView()
                .tabItem {
                    Label("Eksploruj", systemImage: "magnifyingglass")
                }
                .tag(0)
            
            BookingsView()
                .tabItem {
                    Label("Rezerwacje", systemImage: "calendar")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person")
                }
                .tag(2)
        }
        .tint(.indigo)
        .environmentObject(bookingStore)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    MainTabView()
}
