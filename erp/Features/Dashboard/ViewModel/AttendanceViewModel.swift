import Foundation
import Combine

enum AttendanceState {
    case initial
    case loading
    case loaded
    case error(String)
}

@MainActor
class AttendanceViewModel: ObservableObject {
    @Published var state: AttendanceState = .initial
    @Published var semesters = [Semester]()
    @Published var selectedSemesterId: Int?
    @Published var attendanceEntries = [AttendanceEntry]()
    
    // Calculated Properties
    var subjectsGrouped: [String: [AttendanceEntry]] {
        return Dictionary(grouping: attendanceEntries, by: { $0.subjectName })
    }
    
    var totalLectures: Int {
        return attendanceEntries.count
    }
    
    var presentLectures: Int {
        return attendanceEntries.filter { !$0.isAbsent }.count
    }
    
    var overallPercentage: Double {
        guard totalLectures > 0 else { return 0.0 }
        return (Double(presentLectures) / Double(totalLectures)) * 100.0
    }
    
    private let repository = AttendanceRepository()
    
    func loadSemestersAndAttendance() async {
        self.state = .loading
        do {
            let semesters = try await repository.fetchSemesters()
            self.semesters = semesters
            if let firstSem = semesters.first {
                self.selectedSemesterId = firstSem.id
                await fetchAttendance(for: firstSem.userId)
            } else {
                self.state = .loaded
            }
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }
    
    func changeSemester(semesterId: Int) async {
        guard let sem = semesters.first(where: { $0.id == semesterId }) else { return }
        self.selectedSemesterId = semesterId
        self.state = .loading
        await fetchAttendance(for: sem.userId)
    }
    
    private func fetchAttendance(for userId: Int) async {
        do {
            let entries = try await repository.fetchAttendance(userId: userId)
            self.attendanceEntries = entries
            self.state = .loaded
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }
    
    func groupByDate(entries: [AttendanceEntry]) -> [(date: String, status: String)] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy"
        
        var dateMap = [String: [String]]()
        
        for entry in entries {
            guard let absentDate = entry.absentDate else { continue }
            // Parse date
            let parsedDate: Date
            if let date = formatter.date(from: absentDate) {
                parsedDate = date
            } else {
                // Try simple date format
                let fallback = DateFormatter()
                fallback.dateFormat = "yyyy-MM-dd"
                parsedDate = fallback.date(from: absentDate) ?? Date()
            }
            
            let dateKey = outputFormatter.string(from: parsedDate)
            let status = entry.isAbsent ? "A" : "P"
            dateMap[dateKey, default: []].append(status)
        }
        
        return dateMap.map { (date: $0.key, status: $0.value.joined()) }
            .sorted { a, b in
                let dateA = outputFormatter.date(from: a.date) ?? Date.distantPast
                let dateB = outputFormatter.date(from: b.date) ?? Date.distantPast
                return dateB < dateA // Descending
            }
    }
}
