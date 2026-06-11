import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var bookingStore: BookingStore
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    private let basePoints = 2000
    
    var totalPoints: Int {
        basePoints + (bookingStore.bookings.count * 1000)
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
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 70, height: 70)
                            
                            Text("JK")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Jan Kowalski")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("jan.kowalski@student.wsb.poznan.pl")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Program lojalnościowy") {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(statusName)
                                .font(.headline)
                                .foregroundColor(statusColor)
                            Spacer()
                            Text("\(totalPoints) pkt")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        
                        ProgressView(value: Double(totalPoints), total: Double(targetPoints))
                            .tint(statusColor)
                        
                        if totalPoints < 8000 {
                            Text("Zostało \(targetPoints - totalPoints) punktów do Statusu \(nextStatusName)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            Text("Osiągnięto najwyższy status lojalnościowy!")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                Section("Ustawienia i pomoc") {
                    Toggle(isOn: $isDarkMode) {
                        Label("Tryb ciemny", systemImage: "moon.fill")
                    }
                    .tint(.indigo)
                    
                    NavigationLink(destination: ContactFormView()) {
                        Label("Pomoc i wsparcie", systemImage: "questionmark.circle")
                    }
                }
                
                Section("Aplikacja") {
                    HStack {
                        Text("Wersja")
                        Spacer()    
                        Text("0.86")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Profil")
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(BookingStore())
}
