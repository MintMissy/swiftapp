import SwiftUI

struct ContactFormView: View {
    @State private var subject = ""
    @State private var message = ""
    @State private var isShowingAlert = false
    @Environment(\.dismiss) var dismiss
    
    let subjects = ["Problem z rezerwacją", "Płatności i faktury", "Uwagi do pobytu", "Inne"]
    
    var body: some View {
        Form {
            Section(header: Text("Temat wiadomości")) {
                Picker("Wybierz temat", selection: $subject) {
                    Text("Wybierz temat...").tag("")
                    ForEach(subjects, id: \.self) {
                        Text($0).tag($0)
                    }
                }
            }
            
            Section(header: Text("Treść wiadomości")) {
                TextEditor(text: $message)
                    .frame(minHeight: 150)
            }
            
            Section {
                Button(action: {
                    isShowingAlert = true
                }) {
                    Text("Wyślij wiadomość")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .disabled(subject.isEmpty || message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .listRowBackground(
                    (subject.isEmpty || message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) ?
                        Color.gray : Color.indigo
                )
            }
        }
        .navigationTitle("Pomoc i wsparcie")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Wiadomość wysłana", isPresented: $isShowingAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Dziękujemy za kontakt. Odpowiemy najszybciej jak to możliwe.")
        }
    }
}

#Preview {
    NavigationStack {
        ContactFormView()
    }
}
