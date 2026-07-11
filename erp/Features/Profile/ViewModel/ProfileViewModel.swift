import Foundation
import Combine

enum ProfileState {
    case initial
    case loading
    case loaded(UserProfile)
    case error(String)
}

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var state: ProfileState = .initial
    private let repo = ProfileRepository()
    
    func loadProfile() async {
        self.state = .loading
        do {
            let profile = try await repo.fetchUserProfile()
            self.state = .loaded(profile)
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }
}
