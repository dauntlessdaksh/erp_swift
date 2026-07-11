import Foundation

struct LoginResponse: Codable {
    let accessToken: String
    let sessionId: String
    let xUserId: String
    let xToken: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case sessionId = "SessionId"
        case xUserId = "X-UserId"
        case xToken = "X_Token"
        case expiresIn = "expires_in"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        sessionId = try container.decode(String.self, forKey: .sessionId)
        xUserId = try container.decode(String.self, forKey: .xUserId)
        xToken = try container.decode(String.self, forKey: .xToken)
        
        // Handle expiresIn potentially being a string or an int
        if let intValue = try? container.decode(Int.self, forKey: .expiresIn) {
            expiresIn = intValue
        } else if let stringValue = try? container.decode(String.self, forKey: .expiresIn),
                  let parsedInt = Int(stringValue) {
            expiresIn = parsedInt
        } else {
            expiresIn = 172799
        }
    }
    
    init(accessToken: String, sessionId: String, xUserId: String, xToken: String, expiresIn: Int = 172799) {
        self.accessToken = accessToken
        self.sessionId = sessionId
        self.xUserId = xUserId
        self.xToken = xToken
        self.expiresIn = expiresIn
    }
}
