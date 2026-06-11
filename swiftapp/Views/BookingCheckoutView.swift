import SwiftUI

struct BookingCheckoutView: View {
    let hotel: Hotel
    let room: Room
    @EnvironmentObject var bookingStore: BookingStore
    @Environment(\.dismiss) var dismiss
    
    @State private var checkInDate = Date()
    @State private var checkOutDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var guestName = "Jan Kowalski"
    @State private var guestEmail = "jan.kowalski@student.wsb.poznan.pl"
    
    @State private var isLoading = false
    @State private var isSuccess = false
    
    var numberOfNights: Int {
        let calendar = Calendar.current
        let fromDate = calendar.startOfDay(for: checkInDate)
        let toDate = calendar.startOfDay(for: checkOutDate)
        let components = calendar.dateComponents([.day], from: fromDate, to: toDate)
        return max(1, components.day ?? 1)
    }
    
    var basePrice: Double {
        room.pricePerNight * Double(numberOfNights)
    }
    
    var vatPrice: Double {
        basePrice * 0.08
    }
    
    var totalPrice: Double {
        basePrice + vatPrice
    }
    
    var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: guestEmail)
    }
    
    var isFormValid: Bool {
        !guestName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && isEmailValid
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isSuccess {
                    successView
                } else {
                    Form {
                        Section("Szczegóły pokoju") {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(hotel.name)
                                    .font(.headline)
                                Text(room.name)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                        
                        Section("Termin pobytu") {
                            DatePicker(
                                "Zameldowanie",
                                selection: $checkInDate,
                                in: Date()...,
                                displayedComponents: .date
                            )
                            .tint(.indigo)
                            .onChange(of: checkInDate) { newCheckIn in
                                if checkOutDate <= newCheckIn {
                                    checkOutDate = Calendar.current.date(byAdding: .day, value: 1, to: newCheckIn) ?? newCheckIn
                                }
                            }
                            
                            DatePicker(
                                "Wymeldowanie",
                                selection: $checkOutDate,
                                in: Calendar.current.date(byAdding: .day, value: 1, to: checkInDate)!...,
                                displayedComponents: .date
                            )
                            .tint(.indigo)
                        }
                        
                        Section("Dane gościa") {
                            TextField("Imię i nazwisko", text: $guestName)
                            VStack(alignment: .leading, spacing: 4) {
                                TextField("E-mail", text: $guestEmail)
                                    .keyboardType(.emailAddress)
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                                
                                if !guestEmail.isEmpty && !isEmailValid {
                                    Text("Wprowadź poprawny adres e-mail")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        
                        Section("Podsumowanie kosztów") {
                            HStack {
                                Text("Liczba nocy")
                                Spacer()
                                Text("\(numberOfNights)")
                                    .fontWeight(.medium)
                            }
                            
                            HStack {
                                Text("Cena za noc")
                                Spacer()
                                Text("\(Int(room.pricePerNight)) zł")
                            }
                            
                            HStack {
                                Text("Podatek VAT (8%)")
                                Spacer()
                                Text("\(Int(vatPrice)) zł")
                            }
                            
                            HStack {
                                Text("Suma")
                                    .fontWeight(.bold)
                                Spacer()
                                Text("\(Int(totalPrice)) zł")
                                    .font(.headline)
                                    .foregroundColor(.indigo)
                            }
                        }
                    }
                    .safeAreaInset(edge: .bottom) {
                        payButton
                    }
                }
                
                if isLoading {
                    loadingOverlay
                }
            }
            .navigationTitle("Rezerwacja pokoju")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !isSuccess {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Anuluj") {
                            dismiss()
                        }
                        .foregroundColor(.indigo)
                    }
                }
            }
        }
    }
    
    private var payButton: some View {
        Button(action: startPayment) {
            Text("Potwierdź i zapłać")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isFormValid ? LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [.gray], startPoint: .leading, endPoint: .trailing))
                .cornerRadius(12)
                .padding()
        }
        .disabled(!isFormValid)
        .background(Color(.systemGroupedBackground))
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .controlSize(.large)
                    .tint(.white)
                
                Text("Przetwarzanie płatności...")
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
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
            }
            
            VStack(spacing: 8) {
                Text("Rezerwacja pomyślna!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Twój pokój został pomyślnie zarezerwowany. Szczegóły znajdziesz w zakładce Rezerwacje.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            Button(action: completeBooking) {
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
    
    private func startPayment() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            isSuccess = true
        }
    }
    
    private func completeBooking() {
        let code = "RES-\(hotel.name.prefix(2).uppercased())-\(Int.random(in: 1000...9999))"
        let booking = Booking(
            id: UUID(),
            hotelId: hotel.id,
            hotelName: hotel.name,
            hotelLocation: hotel.location,
            roomName: room.name,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            guestName: guestName,
            guestEmail: guestEmail,
            totalPrice: totalPrice,
            qrCodeData: code,
            status: .upcoming
        )
        bookingStore.addBooking(booking)
        dismiss()
        bookingStore.selectedTab = 1
        bookingStore.selectedBookingForDetail = booking
    }
}

#Preview {
    BookingCheckoutView(hotel: MockData.hotels[0], room: MockData.hotels[0].rooms[0])
        .environmentObject(BookingStore())
}
