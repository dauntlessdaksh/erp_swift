import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case unauthorized
    case serverError(statusCode: Int)
    case requestFailed(Error)
    case decodeError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid server URL."
        case .noData:
            return "No data received from the server."
        case .unauthorized:
            return "Session expired or unauthorized. Please login again."
        case .serverError(let code):
            return "Server returned error: \(code)."
        case .requestFailed(let err):
            return err.localizedDescription
        case .decodeError:
            return "Failed to parse server response."
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func request<T: Decodable>(
        urlStr: String,
        method: String = "GET",
        headers: [String: String] = [:],
        body: Data? = nil
    ) async throws -> T {
        guard let url = URL(string: urlStr) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }
        
        if httpResponse.statusCode == 401 {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            // Support dates like ISO8601 or similar if needed
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodeError(error)
        }
    }
}
