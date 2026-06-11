import Foundation
import Combine

enum SortOption: String, CaseIterable, Identifiable {
    case rating = "Ocena (od najwyższej)"
    case priceAsc = "Cena: od najniższej"
    case priceDesc = "Cena: od najwyższej"
    
    var id: String { rawValue }
}

class ExploreViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var filterConfig = FilterConfig()
    @Published var isShowingFilters = false
    @Published var sortOption: SortOption = .rating
    
    var filteredHotels: [Hotel] {
        let baseFiltered = ExploreMockData.hotels.filter { hotel in
            let matchesSearch = searchText.isEmpty ||
                hotel.name.localizedCaseInsensitiveContains(searchText) ||
                hotel.location.localizedCaseInsensitiveContains(searchText)
            
            let matchesPrice = hotel.basePrice <= filterConfig.maxPrice
            let matchesRating = hotel.rating >= filterConfig.minRating
            
            let matchesAmenities = filterConfig.selectedAmenities.isEmpty ||
                filterConfig.selectedAmenities.isSubset(of: Set(hotel.amenities))
            
            return matchesSearch && matchesPrice && matchesRating && matchesAmenities
        }
        
        switch sortOption {
        case .rating:
            return baseFiltered.sorted { $0.rating > $1.rating }
        case .priceAsc:
            return baseFiltered.sorted { $0.basePrice < $1.basePrice }
        case .priceDesc:
            return baseFiltered.sorted { $0.basePrice > $1.basePrice }
        }
    }
}
