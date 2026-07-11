import Foundation
import Combine

enum SplashNavigation {
    case loading
    case login
    case dashboard(LoginResponse)
}

@MainActor
class SplashViewModel: ObservableObject {
    @Published var navigationState: SplashNavigation = .loading
    private let authViewModel = AuthViewModel()
    
    func checkSessionAndAutoLogin() async {
        // Wait 1.5 seconds for branding animation to look premium
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        
        let expiry = KeychainHelper.shared.read(forKey: "tokenExpiry")
        let username = KeychainHelper.shared.read(forKey: "stored_username")
        let password = KeychainHelper.shared.read(forKey: "stored_password")
        
        if let expiryStr = expiry, let expiryMs = Int64(expiryStr) {
            let currentMs = Int64(Date().timeIntervalSince1970 * 1000)
            if currentMs < expiryMs {
                // Token still valid, reconstruct LoginResponse
                if let token = KeychainHelper.shared.read(forKey: "accessToken"),
                   let session = KeychainHelper.shared.read(forKey: "sessionId"),
                   let userId = KeychainHelper.shared.read(forKey: "xUserId"),
                   let xToken = KeychainHelper.shared.read(forKey: "xToken") {
                    
                    let response = LoginResponse(
                        accessToken: token,
                        sessionId: session,
                        xUserId: userId,
                        xToken: xToken
                    )
                    self.navigationState = .dashboard(response)
                    return
                }
            }
        }
        
        // Expiry invalid or not found, try auto-login if credentials exist
        if let user = username, let pass = password {
            authViewModel.username = user
            authViewModel.password = pass
            await authViewModel.login()
            
            switch authViewModel.authState {
            case .success(let response):
                self.navigationState = .dashboard(response)
            default:
                self.navigationState = .login
            }
        } else {
            self.navigationState = .login
        }
    }
}
