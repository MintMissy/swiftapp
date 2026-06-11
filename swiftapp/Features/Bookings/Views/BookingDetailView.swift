import SwiftUI
import MapKit

struct BookingDetailView: View {
    @StateObject private var viewModel: BookingDetailViewModel
    @Environment(\.dismiss) var dismiss
    
    init(bookingId: UUID) {
        _viewModel = StateObject(wrappedValue: BookingDetailViewModel(bookingId: bookingId))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    ticketCardView
                    
                    premiumActionsSection
                    
                    detailsSection
                    
                    roomServiceOrdersSection
                    
                    instructionsSection
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Karta pobytu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Zamknij") {
                        dismiss()
                    }
                    .foregroundColor(.indigo)
                    .fontWeight(.semibold)
                }
            }
            .background(Color(.systemGroupedBackground))
            .sheet(isPresented: $viewModel.isShowingDigitalKey) {
                DigitalKeyView(hotelName: viewModel.booking.hotelName, roomName: viewModel.booking.roomName)
            }
            .sheet(isPresented: $viewModel.isShowingRoomService) {
                RoomServiceView(bookingId: viewModel.booking.id, hotelName: viewModel.booking.hotelName, roomName: viewModel.booking.roomName)
            }
        }
    }
    
    private var ticketCardView: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text(viewModel.booking.hotelName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(viewModel.booking.hotelLocation)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            HStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Zameldowanie")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(viewModel.formatDate(viewModel.booking.checkInDate))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                Image(systemName: "arrow.right")
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Wymeldowanie")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(viewModel.formatDate(viewModel.booking.checkOutDate))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            
            Divider()
            
            QRCodeView(data: viewModel.booking.qrCodeData)
                .padding(.vertical, 8)
            
            Text("Pokaż ten kod na recepcji podczas meldowania.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(24)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
    }
    
    private var premiumActionsSection: some View {
        HStack(spacing: 16) {
            Button(action: { viewModel.isShowingDigitalKey = true }) {
                HStack {
                    Image(systemName: "key.fill")
                    Text("Klucz cyfrowy")
                }
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.indigo)
                .cornerRadius(12)
            }
            
            if viewModel.isBookingActiveByDate {
                Button(action: { viewModel.isShowingRoomService = true }) {
                    HStack {
                        Image(systemName: "fork.knife")
                        Text("Room Service")
                    }
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.purple)
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Szczegóły rezerwacji")
                .font(.headline)
            
            VStack(spacing: 12) {
                detailRow(title: "Pokój", value: viewModel.booking.roomName)
                detailRow(title: "Gość", value: viewModel.booking.guestName)
                detailRow(title: "E-mail", value: viewModel.booking.guestEmail)
                detailRow(title: "Cena całkowita", value: "\(Int(viewModel.booking.totalPrice)) zł")
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
    }
    
    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Wskazówki dla gościa")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "clock")
                        .foregroundColor(.indigo)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Godziny meldunku")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("Zameldowanie od 15:00. Wymeldowanie do 11:00.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Divider()
                
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "map")
                        .foregroundColor(.indigo)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Dojazd")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text(viewModel.booking.hotelLocation)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button(action: viewModel.openMaps) {
                            Text("Otwórz w Mapach")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.indigo)
                        }
                        .padding(.top, 2)
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
    }
    
    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }
    
    private var roomServiceOrdersSection: some View {
        Group {
            if !viewModel.booking.roomServiceOrders.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Historia zamówień Room Service")
                        .font(.headline)
                        .padding(.top, 4)
                    
                    ForEach(viewModel.booking.roomServiceOrders) { order in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Label(viewModel.formatTime(order.timestamp), systemImage: "clock.fill")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(order.status)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.orange.opacity(0.15))
                                    .foregroundColor(.orange)
                                    .cornerRadius(6)
                            }
                            
                            Divider()
                            
                            ForEach(order.items) { item in
                                HStack {
                                    Text("\(item.quantity)x \(item.name)")
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    if item.price > 0 {
                                        Text("\(Int(item.price * Double(item.quantity))) zł")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    } else {
                                        Text("Bezpłatnie")
                                            .font(.subheadline)
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Suma")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("\(Int(order.totalPrice)) zł")
                                    .fontWeight(.bold)
                                    .foregroundColor(.indigo)
                            }
                            .font(.subheadline)
                        }
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.02), radius: 3, x: 0, y: 1)
                    }
                }
            }
        }
    }
}

#Preview {
    BookingDetailView(bookingId: BookingsMockData.bookings[0].id)
}
