import Foundation

class ProfileRepository {
    private func getHeaders() throws -> [String: String] {
        guard let token = KeychainHelper.shared.read(forKey: "accessToken"),
              let session = KeychainHelper.shared.read(forKey: "sessionId"),
              let userId = KeychainHelper.shared.read(forKey: "xUserId"),
              let xToken = KeychainHelper.shared.read(forKey: "xToken") else {
            throw NetworkError.unauthorized
        }
        
        return [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "x-wb": "1",
            "sessionid": session,
            "x-contextid": "194",
            "x-userid": userId,
            "x_token": xToken,
            "x-rx": "1",
            "User-Agent": "ERP/1.0"
        ]
    }
    
    func fetchUserProfile() async throws -> UserProfile {
        let headers = try getHeaders()
        guard let userId = headers["x-userid"] else {
            throw NetworkError.unauthorized
        }
        
        let urlStr = "https://erp.akgec.ac.in/api/User?Id=\(userId)&val=0&val1=0&val2=0&val3=0"
        
        return try await NetworkManager.shared.request(
            urlStr: urlStr,
            method: "GET",
            headers: headers
        )
    }
}
