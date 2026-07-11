import Foundation

struct UserProfile: Decodable {
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
    
    // Dynamic coding keys to decode values from JSON
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        let fName = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "firstName")!) ?? ""
        let mName = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "middleName")!) ?? ""
        let lName = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "lastName")!) ?? ""
        
        self.firstName = fName
        self.fullName = [fName, mName, lName]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
            
        self.contactNumber = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "smsMobileNumber")!) ?? ""
        self.rollNumber = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "rollNumber")!) ?? ""
        self.semester = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "semester")!) ?? ""
        self.section = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "sectionName")!) ?? ""
        
        let rawDob = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "dob")!) ?? ""
        self.dob = rawDob.components(separatedBy: "T").first ?? ""
        
        self.address = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "address")!) ?? ""
        self.fatherName = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "fatherName")!) ?? ""
        self.motherName = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "motherName")!) ?? ""
        self.parentMobileNumber = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "parentMobileNumber")!) ?? ""
        self.collegeEmail = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "email")!) ?? ""
    }
}
