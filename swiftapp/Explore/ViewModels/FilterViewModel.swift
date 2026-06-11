import Foundation
import Combine

class FilterViewModel: ObservableObject {
    @Published var localConfig: FilterConfig
    var onApply: ((FilterConfig) -> Void)?
    
    init(config: FilterConfig, onApply: ((FilterConfig) -> Void)? = nil) {
        self.localConfig = config
        self.onApply = onApply
    }
    
    func toggleRating(_ rating: Double) {
        localConfig.minRating = localConfig.minRating == rating ? 0.0 : rating
    }
    
    func toggleAmenity(_ amenity: Amenity) {
        if localConfig.selectedAmenities.contains(amenity) {
            localConfig.selectedAmenities.remove(amenity)
        } else {
            localConfig.selectedAmenities.insert(amenity)
        }
    }
    
    func reset() {
        localConfig = FilterConfig()
    }
    
    func apply() {
        onApply?(localConfig)
    }
}
