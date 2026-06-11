import SwiftUI

struct BookingsView: View {
    @StateObject private var viewModel: BookingsViewModel
    
    init(bookingStore: BookingStore) {
        _viewModel = StateObject(wrappedValue: BookingsViewModel(bookingStore: bookingStore))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Status rezerwacji", selection: $viewModel.selectedTab) {
                    Text("Nadchodzące").tag(BookingStatus.upcoming)
                    Text("Minione").tag(BookingStatus.past)
                }
                .pickerStyle(.segmented)
                .padding()
                
                if viewModel.filteredBookings.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.filteredBookings) { booking in
                                BookingCardView(booking: booking) {
                                    viewModel.selectedBookingForDetail = booking
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Rezerwacje")
            .background(Color(.systemGroupedBackground))
            .sheet(item: $viewModel.selectedBookingForDetail) { booking in
                BookingDetailView(bookingId: booking.id)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            
            Text("Brak rezerwacji")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("Nie masz jeszcze żadnych rezerwacji w tej kategorii.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
        }
    }
}

struct BookingCardView: View {
    let booking: Booking
    var onTapTicket: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(booking.hotelName)
                        .font(.headline)
                    Text(booking.hotelLocation)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                
                Text(booking.status == .upcoming ? "Potwierdzona" : "Zakończona")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(booking.status == .upcoming ? Color.green.opacity(0.15) : Color.gray.opacity(0.15))
                    .foregroundColor(booking.status == .upcoming ? .green : .gray)
                    .cornerRadius(8)
            }
            
            Divider()
            
            HStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Zameldowanie")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formatDate(booking.checkInDate))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                Image(systemName: "arrow.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Wymeldowanie")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formatDate(booking.checkOutDate))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(booking.roomName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Razem: \(Int(booking.totalPrice)) zł")
                        .font(.headline)
                        .foregroundColor(.indigo)
                }
                
                Spacer()
                
                Button(action: onTapTicket) {
                    HStack {
                        Image(systemName: "qrcode")
                        Text("Karta pobytu")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 3)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "pl_PL")
        return formatter.string(from: date)
    }
}

#Preview {
    BookingsView()
        .environmentObject(BookingStore())
}
