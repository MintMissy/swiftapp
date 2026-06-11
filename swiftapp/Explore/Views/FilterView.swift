import SwiftUI

struct FilterConfig: Equatable {
    var maxPrice: Double = 1000.0
    var minRating: Double = 0.0
    var selectedAmenities: Set<Amenity> = []
}

struct FilterView: View {
    @StateObject private var viewModel: FilterViewModel
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: FilterViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
                        viewModel.reset()
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
                Text("\(Int(viewModel.localConfig.maxPrice)) zł")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.indigo)
            }
            
            Slider(value: $viewModel.localConfig.maxPrice, in: 200...1000, step: 50)
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
                            viewModel.toggleRating(rating)
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(viewModel.localConfig.minRating >= rating ? .yellow : .gray)
                                Text(String(format: "%.1f+", rating))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(viewModel.localConfig.minRating >= rating ? Color.indigo.opacity(0.1) : Color(.systemGray6))
                            .foregroundColor(viewModel.localConfig.minRating >= rating ? .indigo : .primary)
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
                    let isSelected = viewModel.localConfig.selectedAmenities.contains(amenity)
                    Button(action: {
                        viewModel.toggleAmenity(amenity)
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
            viewModel.apply()
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
    FilterView(viewModel: FilterViewModel(config: FilterConfig()))
}
