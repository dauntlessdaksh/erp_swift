import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    let onLoginSuccess: (LoginResponse) -> Void
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            // Premium background gradient
            LinearGradient(
                colors: [Color(red: 2/255, green: 6/255, blue: 23/255), Color(red: 15/255, green: 23/255, blue: 42/255)],
                startPoint: .topLeading,
                endPoint: .bottomRight
            )
            .ignoresSafeArea()
            
            // Glowing circles for rich premium aesthetics
            VStack {
                HStack {
                    Spacer()
                    Circle()
                        .fill(Color(red: 99/255, green: 102/255, blue: 241/255).opacity(0.15))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: 100, y: -100)
                }
                Spacer()
                HStack {
                    Circle()
                        .fill(Color(red: 79/255, green: 70/255, blue: 229/255).opacity(0.12))
                        .frame(width: 250, height: 250)
                        .blur(radius: 50)
                        .offset(x: -80, y: 100)
                    Spacer()
                }
            }
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    Spacer()
                        .frame(height: 60)
                    
                    // Welcome Title
                    VStack(spacing: 8) {
                        Text("Welcome Back")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Sign in to continue")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    
                    // Glassmorphic Card
                    VStack(spacing: 20) {
                        // Username Field
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.white.opacity(0.6))
                                .frame(width: 24)
                            TextField("", text: $viewModel.username, prompt: Text("Username").foregroundColor(.white.opacity(0.35)))
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 16)
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        
                        // Password Field
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.white.opacity(0.6))
                                .frame(width: 24)
                            SecureField("", text: $viewModel.password, prompt: Text("Password").foregroundColor(.white.opacity(0.35)))
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 16)
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        
                        // Sign In Button
                        Button(action: {
                            Task {
                                await viewModel.login()
                            }
                        }) {
                            HStack {
                                Spacer()
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Sign In")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 16)
                            .background(Color(red: 46/255, green: 158/255, blue: 91/255))
                            .cornerRadius(14)
                            .shadow(color: Color(red: 46/255, green: 158/255, blue: 91/255).opacity(0.3), radius: 10, y: 5)
                        }
                        .disabled(isLoading)
                    }
                    .padding(24)
                    .background(
                        Color.white.opacity(0.04)
                            .blur(radius: 0.5)
                    )
                    .cornerRadius(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.15), .clear, .white.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomRight
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .padding(.horizontal, 24)
                    .shadow(color: Color.black.opacity(0.35), radius: 30, x: 0, y: 15)
                }
            }
        }
        .onReceive(viewModel.$authState) { state in
            switch state {
            case .initial:
                self.isLoading = false
            case .loading:
                self.isLoading = true
            case .success(let loginResponse):
                self.isLoading = false
                onLoginSuccess(loginResponse)
            case .failure(let errorMsg):
                self.isLoading = false
                self.alertMessage = errorMsg
                self.showAlert = true
            }
        }
        .alert("Login Failed", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
}

#Preview {
    LoginView(onLoginSuccess: { _ in })
}
