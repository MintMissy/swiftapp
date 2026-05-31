import SwiftUI
import MapKit

struct HotelDetailView: View {
    let hotel: Hotel
    @Environment(\.dismiss) var dismiss
    
    @State private var region: MKCoordinateRegion
    @State private var selectedRoomForBooking: Room? = nil
    
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
        
        _region = State(initialValue: MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                
                VStack(alignment: .leading, spacing: 24) {
                    titleAndDescriptionSection
                    
                    amenitiesGridSection
                    
                    locationMapSection
                    
                    roomsListSection
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                }
            }
        }
        .sheet(item: $selectedRoomForBooking) { room in
            BookingCheckoutView(hotel: hotel, room: room)
        }
    }
    
    private var headerSection: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [.indigo, .purple, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 280)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: hotel.imageName)
                        .font(.largeTitle)
                        .foregroundColor(.white.opacity(0.9))
                    Spacer()
                }
            }
            .padding(24)
            .padding(.bottom, 12)
        }
    }
    
    private var titleAndDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(hotel.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(hotel.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", hotel.rating))
                        .fontWeight(.bold)
                    Text("(\(hotel.reviewCount))")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(8)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(8)
            }
            
            Text(hotel.description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
    }
    
    private var amenitiesGridSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Udogodnienia")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(hotel.amenities) { amenity in
                    HStack(spacing: 8) {
                        Image(systemName: amenity.iconName)
                            .foregroundColor(.indigo)
                        Text(amenity.displayName)
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding(10)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(8)
                }
            }
        }
    }
    
    private var locationMapSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Lokalizacja")
                .font(.headline)
            
            Map(coordinateRegion: $region, annotationItems: [hotel]) { place in
                MapMarker(coordinate: {
                    if place.location.contains("Poznań") {
                        return CLLocationCoordinate2D(latitude: 52.4069, longitude: 16.9299)
                    } else if place.location.contains("Sopot") {
                        return CLLocationCoordinate2D(latitude: 54.4418, longitude: 18.5601)
                    } else if place.location.contains("Zakopane") {
                        return CLLocationCoordinate2D(latitude: 49.2992, longitude: 19.9495)
                    } else {
                        return CLLocationCoordinate2D(latitude: 52.2297, longitude: 21.0122)
                    }
                }(), tint: .indigo)
            }
            .frame(height: 160)
            .cornerRadius(12)
        }
    }
    
    private var roomsListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Dostępne pokoje")
                .font(.headline)
            
            ForEach(hotel.rooms) { room in
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(room.name)
                                .font(.headline)
                            
                            HStack(spacing: 12) {
                                Label("\(room.capacity) os.", systemImage: "person.2.fill")
                                Label(room.bedType, systemImage: "bed.double.fill")
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("\(Int(room.pricePerNight)) zł")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.indigo)
                    }
                    
                    Text(room.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button(action: { selectedRoomForBooking = room }) {
                        Text("Wybierz pokój")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HotelDetailView(hotel: MockData.hotels[0])
            .environmentObject(BookingStore())
    }
}
