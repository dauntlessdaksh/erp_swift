import Foundation

struct TransportAttendanceModel: Codable, Identifiable, Hashable {
    var id: String {
        return "\(attendanceDateString)-\(isInAbsent)-\(remarks ?? "")"
    }
    let attendanceDateString: String
    let isInAbsent: Bool
    let remarks: String?
    
    var attendanceDate: Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: attendanceDateString) {
            return date
        }
        let fallbackFormatter = DateFormatter()
        fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return fallbackFormatter.date(from: attendanceDateString) ?? Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case attendanceDateString = "attendanceDate"
        case isInAbsent
        case remarks
    }
}
