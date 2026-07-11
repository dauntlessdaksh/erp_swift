import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel()
    let onNavigate: (SplashNavigation) -> Void
    
    var body: some View {
        ZStack {
            // Premium background gradient
            LinearGradient(
                colors: [Color(red: 2/255, green: 6/255, blue: 23/255), Color(red: 15/255, green: 23/255, blue: 42/255)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Subtle glowing circles
            VStack {
                Circle()
                    .fill(Color(red: 99/255, green: 102/255, blue: 241/255).opacity(0.12))
                    .frame(width: 400, height: 400)
                    .blur(radius: 80)
                    .offset(y: -100)
                Spacer()
            }
            
            VStack(spacing: 30) {
                Spacer()
                
                // Welcome Text
                VStack(spacing: 12) {
                    Text("Welcome to")
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("UpMark !")
                        .font(.system(size: 48, weight: .heavy, design: .rounded))
                        .italic()
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
                }
                
                Spacer()
                
                // Logo Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white.opacity(0.04))
                        .frame(width: 160, height: 160)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1.5)
                        )
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(red: 99/255, green: 102/255, blue: 241/255), Color(red: 79/255, green: 70/255, blue: 229/255)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color(red: 99/255, green: 102/255, blue: 241/255).opacity(0.5), radius: 15)
                }
                
                Spacer()
                
                // Progress Loader
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 99/255, green: 102/255, blue: 241/255)))
                    .scaleEffect(1.5)
                    .padding(.bottom, 60)
            }
        }
        .onAppear {
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
