import Foundation
import Combine

enum TransportAttendanceState {
    case initial
    case loading
    case loaded([TransportAttendanceModel])
    case error(String)
}

@MainActor
class TransportAttendanceViewModel: ObservableObject {
    @Published var state: TransportAttendanceState = .initial
    private let repo = TransportAttendanceRepo()
    
    func loadAttendance() async {
        self.state = .loading
        do {
            var list = try await repo.fetchAttendance()
            // Sort by date descending
            list.sort { $1.attendanceDate < $0.attendanceDate }
            self.state = .loaded(list)
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }
}
