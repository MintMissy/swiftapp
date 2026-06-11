import Foundation
import Combine

class ContactFormViewModel: ObservableObject {
    @Published var subject = ""
    @Published var message = ""
    @Published var isShowingAlert = false
    
    let subjects = ProfileMockData.contactSubjects
    
    var isValid: Bool {
        !subject.isEmpty && !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func submitMessage() {
        if isValid {
            isShowingAlert = true
        }
    }
}
