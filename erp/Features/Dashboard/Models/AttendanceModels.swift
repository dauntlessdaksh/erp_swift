import Foundation

struct Semester: Identifiable, Hashable {
    let id: Int
    let name: String
    let userId: Int
    let courseName: String
    let batchName: String
}

struct AttendanceEntry: Codable, Identifiable, Hashable {
    var id: String {
        return "\(subjectName)-\(absentDate ?? "")-\(isAbsent)"
    }
    let subjectName: String
    let isAbsent: Bool
    let absentDate: String?
    
    enum CodingKeys: String, CodingKey {
        case subjectName
        case isAbsent
        case absentDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        subjectName = try container.decodeIfPresent(String.self, forKey: .subjectName) ?? "Unknown Subject"
        isAbsent = try container.decodeIfPresent(Bool.self, forKey: .isAbsent) ?? false
        absentDate = try container.decodeIfPresent(String.self, forKey: .absentDate)
    }
    
    init(subjectName: String, isAbsent: Bool, absentDate: String?) {
        self.subjectName = subjectName
        self.isAbsent = isAbsent
        self.absentDate = absentDate
    }
}
