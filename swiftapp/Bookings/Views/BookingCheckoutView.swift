import SwiftUI

struct BookingCheckoutView: View {
    @StateObject private var viewModel: BookingCheckoutViewModel
    @Environment(\.dismiss) var dismiss
    
    init(hotel: Hotel, room: Room, bookingStore: BookingStore) {
        _viewModel = StateObject(wrappedValue: BookingCheckoutViewModel(hotel: hotel, room: room, bookingStore: bookingStore))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isSuccess {
                    successView
                } else {
                    Form {
                        Section("Szczegóły pokoju") {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(viewModel.hotel.name)
                                    .font(.headline)
                                Text(viewModel.room.name)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                        
                        Section("Termin pobytu") {
                            DatePicker(
                                "Zameldowanie",
                                selection: $viewModel.checkInDate,
                                in: Date()...,
                                displayedComponents: .date
                            )
                            .tint(.indigo)
                            .onChange(of: viewModel.checkInDate) { newCheckIn in
                                viewModel.onCheckInDateChange(newCheckIn: newCheckIn)
                            }
                            
                            DatePicker(
                                "Wymeldowanie",
                                selection: $viewModel.checkOutDate,
                                in: Calendar.current.date(byAdding: .day, value: 1, to: viewModel.checkInDate)!...,
                                displayedComponents: .date
                            )
                            .tint(.indigo)
                        }
                        
                        Section("Dane gościa") {
                            TextField("Imię i nazwisko", text: $viewModel.guestName)
                            VStack(alignment: .leading, spacing: 4) {
                                TextField("E-mail", text: $viewModel.guestEmail)
                                    .keyboardType(.emailAddress)
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                                
                                if !viewModel.guestEmail.isEmpty && !viewModel.isEmailValid {
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
                                Text("\(viewModel.numberOfNights)")
                                    .fontWeight(.medium)
                            }
                            
                            HStack {
                                Text("Cena za noc")
                                Spacer()
                                Text("\(Int(viewModel.room.pricePerNight)) zł")
                            }
                            
                            HStack {
                                Text("Podatek VAT (8%)")
                                Spacer()
                                Text("\(Int(viewModel.vatPrice)) zł")
                            }
                            
                            HStack {
                                Text("Suma")
                                    .fontWeight(.bold)
                                Spacer()
                                Text("\(Int(viewModel.totalPrice)) zł")
                                    .font(.headline)
                                    .foregroundColor(.indigo)
                            }
                        }
                    }
                    .safeAreaInset(edge: .bottom) {
                        payButton
                    }
                }
                
                if viewModel.isLoading {
                    loadingOverlay
                }
            }
            .navigationTitle("Rezerwacja pokoju")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !viewModel.isSuccess {
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
        Button(action: viewModel.startPayment) {
            Text("Potwierdź i zapłać")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.isFormValid ? LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [.gray], startPoint: .leading, endPoint: .trailing))
                .cornerRadius(12)
                .padding()
        }
        .disabled(!viewModel.isFormValid)
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
            
            Button(action: {
                viewModel.completeBooking {
                    dismiss()
                }
            }) {
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
    let store = BookingStore()
    return BookingCheckoutView(hotel: MockData.hotels[0], room: MockData.hotels[0].rooms[0], bookingStore: store)
}
