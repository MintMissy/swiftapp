import SwiftUI
import MapKit

class HotelDetailViewModel: ObservableObject {
    let hotel: Hotel
    @Published var region: MKCoordinateRegion
    @Published var selectedRoomForBooking: Room? = nil
    
    init(hotel: Hotel) {
        self.hotel = hotel
        
        let coordinate: CLLocationCoordinate2D
        if hotel.location.contains("Poznań") {
            coordinate = CLLocationCoordinate2D(latitude: 52.4069, longitude: 16.9299)
        } else if hotel.location.contains("Sopot") {
            coordinate = CLLocationCoordinate2D(latitude: 54.4418, longitude: 18.5601)
        } else if hotel.location.contains("Zakopane") {
            coordinate = CLLocationCoordinate2D(latitude: 49.2992, longitude: 19.9495)
        } else {
            coordinate = CLLocationCoordinate2D(latitude: 52.2297, longitude: 21.0122)
        }
        
        self.region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
}
