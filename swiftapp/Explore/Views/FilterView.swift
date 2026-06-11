import SwiftUI

struct FilterConfig: Equatable {
    var maxPrice: Double = 1000.0
    var minRating: Double = 0.0
    var selectedAmenities: Set<Amenity> = []
}

struct FilterView: View {
    @Binding var config: FilterConfig
    @Environment(\.dismiss) var dismiss
    
    @State private var localConfig: FilterConfig
    
    init(config: Binding<FilterConfig>) {
        _config = config
        _localConfig = State(initialValue: config.wrappedValue)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        priceSection
                        ratingSection
                        amenitiesSection
                    }
                    .padding()
                }
                
                applyButton
            }
            .navigationTitle("Filtry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Resetuj") {
                        localConfig = FilterConfig()
                    }
                    .foregroundColor(.indigo)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
    
    private var priceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Maksymalna cena")
                    .font(.headline)
                Spacer()
                Text("\(Int(localConfig.maxPrice)) zł")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.indigo)
            }
            
            Slider(value: $localConfig.maxPrice, in: 200...1000, step: 50)
                .tint(.indigo)
        }
    }
    
    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Minimalna ocena")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(stride(from: 3.0, through: 5.0, by: 0.5)), id: \.self) { rating in
                        Button(action: {
                            localConfig.minRating = localConfig.minRating == rating ? 0.0 : rating
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(localConfig.minRating >= rating ? .yellow : .gray)
                                Text(String(format: "%.1f+", rating))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(localConfig.minRating >= rating ? Color.indigo.opacity(0.1) : Color(.systemGray6))
                            .foregroundColor(localConfig.minRating >= rating ? .indigo : .primary)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 4)
            }
        }
    }
    
    private var amenitiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Udogodnienia")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(Amenity.allCases) { amenity in
                    let isSelected = localConfig.selectedAmenities.contains(amenity)
                    Button(action: {
                        if isSelected {
                            localConfig.selectedAmenities.remove(amenity)
                        } else {
                            localConfig.selectedAmenities.insert(amenity)
                        }
                    }) {
                        HStack {
                            Image(systemName: amenity.iconName)
                            Text(amenity.displayName)
                                .font(.caption)
                                .lineLimit(1)
                            Spacer()
                        }
                        .padding(10)
                        .background(isSelected ? Color.indigo.opacity(0.1) : Color(.systemGray6))
                        .foregroundColor(isSelected ? .indigo : .primary)
                        .cornerRadius(10)
                    }
                }
            }
        }
    }
    
    private var applyButton: some View {
        Button(action: {
            config = localConfig
            dismiss()
        }) {
            Text("Zastosuj filtry")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(12)
                .padding()
        }
    }
}

#Preview {
    FilterView(config: .constant(FilterConfig()))
}
