import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel()
    let onNavigate: (SplashNavigation) -> Void
    @Environment(\.colorScheme) var colorScheme
    
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0
    @State private var logoRotation: Double = -45.0
    @State private var textOpacity: Double = 0.0
    @State private var textOffset: CGFloat = 20.0
    @State private var pulseScale: CGFloat = 0.8
    @State private var pulseOpacity: Double = 0.6
    
    var body: some View {
        ZStack {
            // Dynamic background following app theme selection
            Color.appBackground.ignoresSafeArea()
            
            // Pulsing halo glow behind logo
            Circle()
                .fill(Color.appGreen.opacity(0.18))
                .frame(width: 220, height: 220)
                .scaleEffect(pulseScale)
                .opacity(pulseOpacity)
                .blur(radius: 20)
            
            VStack(spacing: 30) {
                Spacer()
                
                // Welcome Text
                VStack(spacing: 12) {
                    Text("Welcome to")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.appTextSecondary)
                    
                    Text("UpMark")
                        .font(.system(size: 52, weight: .black, design: .rounded))
                        .foregroundColor(.appTextPrimary)
                        .shadow(color: Color.appTextPrimary.opacity(0.06), radius: 10, y: 5)
                }
                .opacity(textOpacity)
                .offset(y: textOffset)
                
                Spacer()
                
                // Animated Logo Container
                ZStack {
                    RoundedRectangle(cornerRadius: 44)
                        .fill(Color.appCard)
                        .frame(width: 170, height: 170)
                        .overlay(
                            RoundedRectangle(cornerRadius: 44)
                                .stroke(Color.appTextPrimary.opacity(0.08), lineWidth: 1.5)
                        )
                        .premiumCardShadow(colorScheme: colorScheme)
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 85))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.appGreen, Color(red: 52/255, green: 211/255, blue: 153/255)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color.appGreen.opacity(0.4), radius: 12)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                .rotationEffect(.degrees(logoRotation))
                
                Spacer()
                
                // Progress Indicator
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.appGreen))
                    .scaleEffect(1.5)
                    .padding(.bottom, 60)
            }
        }
        .onAppear {
            // Spring animate logo scale & rotation
            withAnimation(.spring(response: 0.65, dampingFraction: 0.55, blendDuration: 0).delay(0.1)) {
                logoScale = 1.0
                logoOpacity = 1.0
                logoRotation = 0.0
            }
            
            // Fade-in welcoming labels
            withAnimation(.easeOut(duration: 0.8).delay(0.35)) {
                textOpacity = 1.0
                textOffset = 0.0
            }
            
            // Continuous halo pulse
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                pulseScale = 1.25
                pulseOpacity = 0.04
            }
            
            Task {
                await viewModel.checkSessionAndAutoLogin()
            }
        }
        .onReceive(viewModel.$navigationState) { state in
            if case .loading = state {
                // do nothing
            } else {
                onNavigate(state)
            }
        }
    }
}

#Preview {
    SplashView(onNavigate: { _ in })
}
