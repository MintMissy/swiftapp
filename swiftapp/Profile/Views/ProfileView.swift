import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    
    init(bookingStore: BookingStore) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(bookingStore: bookingStore))
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
                            Text(viewModel.statusName)
                                .font(.headline)
                                .foregroundColor(viewModel.statusColor)
                            Spacer()
                            Text("\(viewModel.totalPoints) pkt")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        
                        ProgressView(value: Double(viewModel.totalPoints), total: Double(viewModel.targetPoints))
                            .tint(viewModel.statusColor)
                        
                        if viewModel.totalPoints < 8000 {
                            Text("Zostało \(viewModel.targetPoints - viewModel.totalPoints) punktów do Statusu \(viewModel.nextStatusName)")
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
                    Toggle(isOn: $viewModel.isDarkMode) {
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
    let store = BookingStore()
    return ProfileView(bookingStore: store)
}
