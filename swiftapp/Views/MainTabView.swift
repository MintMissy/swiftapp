import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var bookingStore = BookingStore()
    
    var body: some View {
        TabView(selection: $selectedTab) {
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
    }
}

#Preview {
    MainTabView()
}
