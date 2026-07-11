import Foundation

class TransportAttendanceRepo {
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
    
    func fetchAttendance() async throws -> [TransportAttendanceModel] {
        let headers = try getHeaders()
        
        guard let username = KeychainHelper.shared.read(forKey: "stored_username"), username.count > 3 else {
            throw NSError(domain: "TransportAttendance", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid student username stored."])
        }
        
        let studentNumber = String(username.prefix(username.count - 3))
        let urlStr = "https://erp.akgec.ac.in/api/TransportAttendanceReport?admissionNumber=\(studentNumber)&type=11"
        
        let list: [TransportAttendanceModel] = try await NetworkManager.shared.request(
            urlStr: urlStr,
            method: "GET",
            headers: headers
        )
        
        return list
    }
}
