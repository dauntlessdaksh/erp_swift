import Foundation

class AttendanceRepository {
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
    
    func fetchSemesters() async throws -> [Semester] {
        let headers = try getHeaders()
        guard let userId = headers["x-userid"] else {
            throw NetworkError.unauthorized
        }
        
        let urlStr = "https://erp.akgec.ac.in/api/SubjectAttendance?userFromClient=0&userId=\(userId)"
        
        // Fetch raw response
        let dataList: [[String: Any]] = try await NetworkManager.shared.request(
            urlStr: urlStr,
            method: "GET",
            headers: headers
        )
        
        var seen = Set<Int>()
        var semesters = [Semester]()
        
        for item in dataList {
            let semesterVal = item["semester"]
            let userIdVal = item["userId"]
            
            let semId: Int
            if let intVal = semesterVal as? Int {
                semId = intVal
            } else if let strVal = semesterVal as? String, let parsed = Int(strVal) {
                semId = parsed
            } else {
                continue
            }
            
            let semUserId: Int
            if let intVal = userIdVal as? Int {
                semUserId = intVal
            } else if let strVal = userIdVal as? String, let parsed = Int(strVal) {
                semUserId = parsed
            } else {
                continue
            }
            
            if semId == 0 || semUserId == 0 { continue }
            
            if !seen.contains(semId) {
                seen.insert(semId)
                let courseName = item["courseName"] as? String ?? ""
                let batchName = item["batchName"] as? String ?? ""
                semesters.append(Semester(
                    id: semId,
                    name: "Semester \(semId)",
                    userId: semUserId,
                    courseName: courseName,
                    batchName: batchName
                ))
            }
        }
        
        // Sort descending by id
        semesters.sort { $1.id < $0.id }
        return semesters;
    }
    
    func fetchAttendance(userId: Int) async throws -> [AttendanceEntry] {
        let headers = try getHeaders()
        let urlStr = "https://erp.akgec.ac.in/api/SubjectAttendance/GetPresentAbsentStudent?isDateWise=false&termId=0&userId=\(userId)&y=0"
        
        // Use [String: Any] parsing helper via NetworkManager
        let responseMap: [String: Any] = try await NetworkManager.shared.request(
            urlStr: urlStr,
            method: "GET",
            headers: headers
        )
        
        let regular = responseMap["attendanceData"] as? [[String: Any]] ?? []
        let extra = responseMap["extraLectures"] as? [[String: Any]] ?? []
        
        var subjectMap = [Int: String]()
        for e in regular {
            if let subId = e["subjectId"] as? Int, let subName = e["subjectName"] as? String {
                subjectMap[subId] = subName
            }
        }
        
        var combined = [AttendanceEntry]()
        
        // Process regular
        for item in regular {
            if let name = item["subjectName"] as? String {
                let isAbsent = item["isAbsent"] as? Bool ?? false
                let dateStr = item["absentDate"] as? String
                combined.append(AttendanceEntry(subjectName: name, isAbsent: isAbsent, absentDate: dateStr))
            }
        }
        
        // Process extra
        for item in extra {
            var name = item["subjectName"] as? String
            if name == nil, let subId = item["subjectId"] as? Int {
                name = subjectMap[subId]
            }
            if let name = name {
                let isAbsent = item["isAbsent"] as? Bool ?? false
                let dateStr = item["absentDate"] as? String
                combined.append(AttendanceEntry(subjectName: name, isAbsent: isAbsent, absentDate: dateStr))
            }
        }
        
        return combined
    }
}

// Extend NetworkManager to support custom untyped JSON requests
extension NetworkManager {
    func request(
        urlStr: String,
        method: String = "GET",
        headers: [String: String] = [:],
        body: Data? = nil
    ) async throws -> [[String: Any]] {
        guard let url = URL(string: urlStr) else { throw NetworkError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.noData }
        if httpResponse.statusCode == 401 { throw NetworkError.unauthorized }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
            return json
        }
        throw NetworkError.decodeError(NSError(domain: "", code: -1, userInfo: nil))
    }
    
    func request(
        urlStr: String,
        method: String = "GET",
        headers: [String: String] = [:],
        body: Data? = nil
    ) async throws -> [String: Any] {
        guard let url = URL(string: urlStr) else { throw NetworkError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.noData }
        if httpResponse.statusCode == 401 { throw NetworkError.unauthorized }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return json
        }
        throw NetworkError.decodeError(NSError(domain: "", code: -1, userInfo: nil))
    }
}
