import Foundation
import Combine

class ContactFormViewModel: ObservableObject {
    @Published var subject = ""
    @Published var message = ""
    @Published var isShowingAlert = false
    
    let subjects = ["Problem z rezerwacją", "Płatności i faktury", "Uwagi do pobytu", "Inne"]
    
    var isValid: Bool {
        !subject.isEmpty && !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func submitMessage() {
        if isValid {
            isShowingAlert = true
        }
    }
}
