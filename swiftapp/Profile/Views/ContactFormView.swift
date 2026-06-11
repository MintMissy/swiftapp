import SwiftUI

struct ContactFormView: View {
    @StateObject private var viewModel = ContactFormViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section(header: Text("Temat wiadomości")) {
                Picker("Wybierz temat", selection: $viewModel.subject) {
                    Text("Wybierz temat...").tag("")
                    ForEach(viewModel.subjects, id: \.self) {
                        Text($0).tag($0)
                    }
                }
            }
            
            Section(header: Text("Treść wiadomości")) {
                TextEditor(text: $viewModel.message)
                    .frame(minHeight: 150)
            }
            
            Section {
                Button(action: {
                    viewModel.submitMessage()
                }) {
                    Text("Wyślij wiadomość")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .disabled(!viewModel.isValid)
                .listRowBackground(
                    (!viewModel.isValid) ?
                        Color.gray : Color.indigo
                )
            }
        }
        .navigationTitle("Pomoc i wsparcie")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Wiadomość wysłana", isPresented: $viewModel.isShowingAlert) {
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
