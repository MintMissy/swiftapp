import SwiftUI
import MapKit

struct HotelDetailView: View {
    @StateObject private var viewModel: HotelDetailViewModel
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var bookingStore: BookingStore
    
    init(hotel: Hotel) {
        _viewModel = StateObject(wrappedValue: HotelDetailViewModel(hotel: hotel))
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
        .sheet(item: $viewModel.selectedRoomForBooking) { room in
            BookingCheckoutView(hotel: viewModel.hotel, room: room, bookingStore: bookingStore)
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
                    Image(systemName: viewModel.hotel.imageName)
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
                    Text(viewModel.hotel.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(viewModel.hotel.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", viewModel.hotel.rating))
                        .fontWeight(.bold)
                    Text("(\(viewModel.hotel.reviewCount))")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(8)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(8)
            }
            
            Text(viewModel.hotel.description)
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
                ForEach(viewModel.hotel.amenities) { amenity in
                    HStack(spacing: 8) {
                        Image(systemName: amenity.iconName)
                            .foregroundColor(.indigo)
                        Text(amenity.displayName)
                            .font(.subheadline)
                            .lineLimit(nil)
                        Spacer()
                    }
                    .padding(10)
                    .frame(maxHeight: .infinity)
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
            
            Map(coordinateRegion: $viewModel.region, annotationItems: [viewModel.hotel]) { place in
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
            
            ForEach(viewModel.hotel.rooms) { room in
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
                    
                    Button(action: { viewModel.selectedRoomForBooking = room }) {
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
