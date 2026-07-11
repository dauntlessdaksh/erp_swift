import Foundation

class AuthRepository {
    func login(username: String, password: String) async throws -> LoginResponse {
        let urlStr = "https://erp.akgec.ac.in/Token"
        let bodyString = "grant_type=password&username=\(username)&password=\(password)"
        guard let bodyData = bodyString.data(using: .utf8) else {
            throw NetworkError.requestFailed(NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to build body"]))
        }
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        return try await NetworkManager.shared.request(
            urlStr: urlStr,
            method: "POST",
            headers: headers,
            body: bodyData
        )
    }
}
