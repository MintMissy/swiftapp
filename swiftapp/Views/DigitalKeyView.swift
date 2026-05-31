import SwiftUI

struct DigitalKeyView: View {
    let hotelName: String
    let roomName: String
    @Environment(\.dismiss) var dismiss
    
    @State private var isPulsing = false
    @State private var isUnlocked = false
    
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.4))
                    }
                }
                .padding(.horizontal)
                
                VStack(spacing: 8) {
                    Text(hotelName)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(roomName)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.top)
                
                Spacer()
                
                ZStack {
                    if isUnlocked {
                        Circle()
                            .fill(Color.green.opacity(0.15))
                            .frame(width: 180, height: 180)
                        
                        Image(systemName: "lock.open.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        ForEach(0..<3) { index in
                            Circle()
                                .stroke(Color.indigo.opacity(0.3), lineWidth: 2)
                                .frame(width: CGFloat(100 + index * 40), height: CGFloat(100 + index * 40))
                                .scaleEffect(isPulsing ? 1.2 : 0.8)
                                .opacity(isPulsing ? 0.0 : 1.0)
                                .animation(
                                    .easeOut(duration: 1.5)
                                    .repeatForever(autoreverses: false)
                                    .delay(Double(index) * 0.3),
                                    value: isPulsing
                                )
                        }
                        
                        Circle()
                            .fill(LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 100, height: 100)
                            
                        Image(systemName: "wave.3.left.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    }
                }
                .frame(height: 240)
                
                Spacer()
                
                Text(isUnlocked ? "Pokój otwarty! Wejdź do środka." : "Zbliż telefon do czytnika w drzwiach...")
                    .font(.headline)
                    .foregroundColor(isUnlocked ? .green : .white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .animation(.easeInOut, value: isUnlocked)
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            isPulsing = true
            simulateNFCReaderHandshake()
        }
    }
    
    private func simulateNFCReaderHandshake() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                isUnlocked = true
                isPulsing = false
            }
        }
    }
}

#Preview {
    DigitalKeyView(hotelName: "Grand Poznań Hotel & Spa", roomName: "Pokój Standard Double")
}
