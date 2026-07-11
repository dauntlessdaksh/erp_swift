import Foundation
import Combine

enum AuthState {
    case initial
    case loading
    case success(LoginResponse)
    case failure(String)
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var authState: AuthState = .initial
    
    private let repository = AuthRepository()
    
    func login() async {
        guard !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.authState = .failure("Please enter both username and password.")
            return
        }
        
        self.authState = .loading
        
        do {
            let response = try await repository.login(username: username, password: password)
            
            // Securely store credentials and tokens in Keychain
            KeychainHelper.shared.save(username, forKey: "stored_username")
            KeychainHelper.shared.save(password, forKey: "stored_password")
            KeychainHelper.shared.save(response.accessToken, forKey: "accessToken")
            KeychainHelper.shared.save(response.sessionId, forKey: "sessionId")
            KeychainHelper.shared.save(response.xUserId, forKey: "xUserId")
            KeychainHelper.shared.save(response.xToken, forKey: "xToken")
            
            let expiryDate = Date().addingTimeInterval(TimeInterval(response.expiresIn))
            let expiryMs = String(Int64(expiryDate.timeIntervalSince1970 * 1000))
            KeychainHelper.shared.save(expiryMs, forKey: "tokenExpiry")
            
            self.authState = .success(response)
        } catch {
            self.authState = .failure(error.localizedDescription)
        }
    }
    
    func logout() {
        KeychainHelper.shared.clearAll()
        self.username = ""
        self.password = ""
        self.authState = .initial
    }
}
