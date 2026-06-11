import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = ExploreViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    searchAndFilterBar
                    
                    if viewModel.filteredHotels.isEmpty {
                        emptyStateView
                    } else {
                        featuredSection
                        allHotelsSection
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Eksploruj")
            .background(Color(.systemGroupedBackground))
            .sheet(isPresented: $viewModel.isShowingFilters) {
                FilterView(viewModel: FilterViewModel(config: viewModel.filterConfig) { config in
                    viewModel.filterConfig = config
                })
            }
        }
    }
    
    private var searchAndFilterBar: some View {
        HStack(spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Gdzie chcesz się zatrzymać?", text: $viewModel.searchText)
                    .autocorrectionDisabled()
            }
            .padding(12)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
            
            Menu {
                Picker("Sortuj według", selection: $viewModel.sortOption) {
                    ForEach(SortOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.purple)
                    .cornerRadius(12)
            }
            
            Button(action: { viewModel.isShowingFilters = true }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.indigo)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal)
    }
    
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Polecane miejsca")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.filteredHotels.prefix(2)) { hotel in
                        NavigationLink(destination: HotelDetailView(hotel: hotel)) {
                            FeaturedHotelCard(hotel: hotel)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var allHotelsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Wszystkie hotele")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredHotels) { hotel in
                    NavigationLink(destination: HotelDetailView(hotel: hotel)) {
                        HotelRowView(hotel: hotel)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 40)
            Image(systemName: "building.2.crop.left.filled.to.right")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            
            Text("Brak wyników")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("Spróbuj zmienić parametry wyszukiwania lub filtry.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ExploreView()
}

struct FeaturedHotelCard: View {
    let hotel: Hotel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                LinearGradient(
                    colors: [.indigo, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 240, height: 140)
                
                Image(systemName: hotel.imageName)
                    .font(.system(size: 40))
                    .foregroundColor(.white.opacity(0.85))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", hotel.rating))
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Material.ultraThin)
                .cornerRadius(20)
                .padding(10)
            }
            .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(hotel.name)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                
                Text(hotel.location)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack {
                    Text("od \(Int(hotel.basePrice)) zł")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.indigo)
                    Text("/ noc")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 2)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .frame(width: 240)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

struct HotelRowView: View {
    let hotel: Hotel
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 80, height: 80)
                
                Image(systemName: hotel.imageName)
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.85))
            }
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top) {
                    Text(hotel.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", hotel.rating))
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                }
                
                Text(hotel.location)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack(alignment: .bottom) {
                    Text("od \(Int(hotel.basePrice)) zł")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.indigo)
                    Text("/ noc")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding(.top, 2)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}
