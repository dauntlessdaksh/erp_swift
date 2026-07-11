import Foundation

struct UserProfile: Codable {
    let fullName: String
    let firstName: String
    let contactNumber: String
    let rollNumber: String
    let semester: String
    let section: String
    let dob: String
    let address: String
    let fatherName: String
    let motherName: String
    let parentMobileNumber: String
    let collegeEmail: String
    
    enum CodingKeys: String, CodingKey {
        case firstName
        case middleName
        case lastName
        case smsMobileNumber
        case rollNumber
        case semester
        case sectionName
        case dob
        case address
        case fatherName
        case motherName
        case parentMobileNumber
        case email
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let fName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        let mName = try container.decodeIfPresent(String.self, forKey: .middleName) ?? ""
        let lName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        
        firstName = fName
        fullName = [fName, mName, lName]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
            
        contactNumber = try container.decodeIfPresent(String.self, forKey: .smsMobileNumber) ?? ""
        rollNumber = try container.decodeIfPresent(String.self, forKey: .rollNumber) ?? ""
        semester = try container.decodeIfPresent(String.self, forKey: .semester) ?? ""
        section = try container.decodeIfPresent(String.self, forKey: .sectionName) ?? ""
        
        let rawDob = try container.decodeIfPresent(String.self, forKey: .dob) ?? ""
        dob = rawDob.components(separatedBy: "T").first ?? ""
        
        address = try container.decodeIfPresent(String.self, forKey: .address) ?? ""
        fatherName = try container.decodeIfPresent(String.self, forKey: .fatherName) ?? ""
        motherName = try container.decodeIfPresent(String.self, forKey: .motherName) ?? ""
        parentMobileNumber = try container.decodeIfPresent(String.self, forKey: .parentMobileNumber) ?? ""
        collegeEmail = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
    }
}
