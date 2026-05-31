import SwiftUI

struct ServiceItem: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let price: Double
    let icon: String
}

struct RoomServiceView: View {
    let bookingId: UUID
    let hotelName: String
    let roomName: String
    @EnvironmentObject var bookingStore: BookingStore
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedCategory = "Jedzenie"
    @State private var quantities: [UUID: Int] = [:]
    @State private var isLoading = false
    @State private var isSuccess = false
    
    let menuItems = [
        ServiceItem(name: "Burger wołowy z frytkami", category: "Jedzenie", price: 55.0, icon: "fork.knife"),
        ServiceItem(name: "Sałatka Cezar z kurczakiem", category: "Jedzenie", price: 38.0, icon: "leaf.fill"),
        ServiceItem(name: "Śniadanie kontynentalne", category: "Jedzenie", price: 45.0, icon: "cup.and.saucer.fill"),
        ServiceItem(name: "Kawa Cappuccino", category: "Napoje", price: 15.0, icon: "cup.and.saucer.fill"),
        ServiceItem(name: "Świeżo wyciskany sok", category: "Napoje", price: 18.0, icon: "drop.fill"),
        ServiceItem(name: "Woda niegazowana", category: "Napoje", price: 8.0, icon: "drop"),
        ServiceItem(name: "Czyste ręczniki", category: "Usługi", price: 0.0, icon: "washer.fill"),
        ServiceItem(name: "Sprzątanie pokoju", category: "Usługi", price: 0.0, icon: "sparkles")
    ]
    
    var filteredItems: [ServiceItem] {
        menuItems.filter { $0.category == selectedCategory }
    }
    
    var totalCost: Double {
        menuItems.reduce(0.0) { sum, item in
            sum + (item.price * Double(quantities[item.id] ?? 0))
        }
    }
    
    var cartIsEmpty: Bool {
        !quantities.values.contains { $0 > 0 }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isSuccess {
                    successView
                } else {
                    VStack {
                        Picker("Kategoria", selection: $selectedCategory) {
                            Text("Jedzenie").tag("Jedzenie")
                            Text("Napoje").tag("Napoje")
                            Text("Usługi").tag("Usługi")
                        }
                        .pickerStyle(.segmented)
                        .padding()
                        
                        List {
                            ForEach(filteredItems) { item in
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
                
                if isLoading {
                    loadingOverlay
                }
            }
            .navigationTitle("Room Service")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !isSuccess {
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
        let qty = quantities[item.id] ?? 0
        return HStack(spacing: 12) {
            if qty > 0 {
                Button(action: { quantities[item.id] = qty - 1 }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.indigo)
                }
                
                Text("\(qty)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .frame(minWidth: 20)
            }
            
            Button(action: { quantities[item.id] = qty + 1 }) {
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
                Text("\(Int(totalCost)) zł")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.indigo)
            }
            .padding(.horizontal)
            .padding(.top, 4)
            
            Button(action: submitOrder) {
                Text("Złóż zamówienie do pokoju")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(cartIsEmpty ? Color.gray : Color.indigo)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.bottom, 16)
            }
            .disabled(cartIsEmpty)
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
    
    private func submitOrder() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            
            let orderedItems = menuItems.compactMap { item -> RoomServiceOrderItem? in
                let qty = quantities[item.id] ?? 0
                guard qty > 0 else { return nil }
                return RoomServiceOrderItem(id: UUID(), name: item.name, quantity: qty, price: item.price)
            }
            
            let newOrder = RoomServiceOrder(
                id: UUID(),
                timestamp: Date(),
                items: orderedItems,
                totalPrice: totalCost,
                status: "W przygotowaniu"
            )
            
            bookingStore.addRoomServiceOrder(to: bookingId, order: newOrder)
            isSuccess = true
        }
    }
}

#Preview {
    RoomServiceView(bookingId: UUID(), hotelName: "Grand Poznań Hotel & Spa", roomName: "Pokój Standard Double")
        .environmentObject(BookingStore())
}
