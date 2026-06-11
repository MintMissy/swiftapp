import SwiftUI

struct ServiceItem: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let price: Double
    let icon: String
}

struct RoomServiceView: View {
    @StateObject private var viewModel: RoomServiceViewModel
    @Environment(\.dismiss) var dismiss
    
    init(bookingId: UUID, hotelName: String, roomName: String, bookingService: BookingService) {
        _viewModel = StateObject(wrappedValue: RoomServiceViewModel(bookingId: bookingId, hotelName: hotelName, roomName: roomName, bookingService: bookingService))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isSuccess {
                    successView
                } else {
                    VStack {
                        Picker("Kategoria", selection: $viewModel.selectedCategory) {
                            Text("Jedzenie").tag("Jedzenie")
                            Text("Napoje").tag("Napoje")
                            Text("Usługi").tag("Usługi")
                        }
                        .pickerStyle(.segmented)
                        .padding()
                        
                        List {
                            ForEach(viewModel.filteredItems) { item in
                                HStack(spacing: 16) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.indigo.opacity(0.1))
                                            .frame(width: 44, height: 44)
                                        
                                        Image(systemName: item.icon)
                                            .foregroundColor(.indigo)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.name)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        
                                        if item.price > 0 {
                                            Text("\(Int(item.price)) zł")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        } else {
                                            Text("Bezpłatnie")
                                                .font(.caption)
                                                .foregroundColor(.green)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    quantityControl(for: item)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        
                        checkoutSection
                    }
                }
                
                if viewModel.isLoading {
                    loadingOverlay
                }
            }
            .navigationTitle("Room Service")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !viewModel.isSuccess {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Anuluj") {
                            dismiss()
                        }
                        .foregroundColor(.indigo)
                    }
                }
            }
        }
    }
    
    private func quantityControl(for item: ServiceItem) -> some View {
        let qty = viewModel.getQuantity(for: item)
        return HStack(spacing: 12) {
            if qty > 0 {
                Button(action: { viewModel.decrementQuantity(for: item) }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.indigo)
                }
                
                Text("\(qty)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .frame(minWidth: 20)
            }
            
            Button(action: { viewModel.incrementQuantity(for: item) }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.indigo)
            }
        }
        .buttonStyle(.plain)
    }
    
    private var checkoutSection: some View {
        VStack(spacing: 12) {
            Divider()
            
            HStack {
                Text("Cena całkowita")
                    .font(.headline)
                Spacer()
                Text("\(Int(viewModel.totalCost)) zł")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.indigo)
            }
            .padding(.horizontal)
            .padding(.top, 4)
            
            Button(action: viewModel.submitOrder) {
                Text("Złóż zamówienie do pokoju")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background((viewModel.cartIsEmpty || viewModel.isBookingInactive) ? Color.gray : Color.indigo)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.bottom, 16)
            }
            .disabled(viewModel.cartIsEmpty || viewModel.isBookingInactive)
        }
        .background(Color(.systemBackground))
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .controlSize(.large)
                    .tint(.white)
                Text("Wysyłanie zamówienia...")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
    
    private var successView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "paperplane.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
            }
            
            VStack(spacing: 8) {
                Text("Zamówienie wysłane!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Obsługa pokoju dostarczy Twoje zamówienie za około 25 minut.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            Button(action: { dismiss() }) {
                Text("Gotowe")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
            }
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    let service = BookingService()
    return RoomServiceView(bookingId: UUID(), hotelName: "Grand Poznań Hotel & Spa", roomName: "Pokój Standard Double", bookingService: service)
}
