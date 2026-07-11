import SwiftUI

struct MainShellView: View {
    @State private var selectedTab = 0
    @Environment(\.colorScheme) var colorScheme
    let loginResponse: LoginResponse
    let onLogout: () -> Void
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            // Subtle glowing circle for background visual depth
            VStack {
                HStack {
                    Circle()
                        .fill(Color.appBlue.opacity(colorScheme == .dark ? 0.05 : 0.03))
                        .frame(width: 400, height: 400)
                        .blur(radius: 80)
                        .offset(x: -100, y: -100)
                    Spacer()
                }
                Spacer()
            }
            .ignoresSafeArea()
            
            // Main views container
            VStack(spacing: 0) {
                ZStack {
                    DashboardView(
                        rollNumber: KeychainHelper.shared.read(forKey: "stored_username") ?? loginResponse.xUserId,
                        firstName: "Student"
                    )
                    .opacity(selectedTab == 0 ? 1 : 0)
                    .disabled(selectedTab != 0)
                    
                    IdentityView()
                    .opacity(selectedTab == 1 ? 1 : 0)
                    .disabled(selectedTab != 1)
                    
                    TransportAttendanceView()
                    .opacity(selectedTab == 2 ? 1 : 0)
                    .disabled(selectedTab != 2)
                    
                    ProfileView(onLogout: onLogout)
                    .opacity(selectedTab == 3 ? 1 : 0)
                    .disabled(selectedTab != 3)
                }
            }
            
            // Custom floating tab bar at the bottom
            VStack {
                Spacer()
                
                HStack(spacing: 24) {
                    TabBarItem(iconName: "house", isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }
                    TabBarItem(iconName: "person.crop.rectangle", isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }
                    TabBarItem(iconName: "cpu", isSelected: selectedTab == 2) {
                        selectedTab = 2
                    }
                    TabBarItem(iconName: "person", isSelected: selectedTab == 3) {
                        selectedTab = 3
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(colorScheme == .light ? Color.white.opacity(0.85) : Color.cardBackground.opacity(0.85))
                .background(.ultraThinMaterial)
                .cornerRadius(32)
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(Color.divider, lineWidth: 1.5)
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
                .shadow(color: Color.shadow, radius: 16, x: 0, y: 6)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

struct TabBarItem: View {
    let iconName: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isSelected ? "\(iconName).fill" : iconName)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? Color.accentGreen : Color.secondaryText)
                .padding(12)
                .background(isSelected ? (colorScheme == .light ? Color.secondaryCard : Color.cardBackground.opacity(0.5)) : Color.clear)
                .cornerRadius(16)
                .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(TactileButtonStyle())
    }
}

#Preview {
    MainShellView(
        loginResponse: LoginResponse(
            accessToken: "123",
            sessionId: "456",
            xUserId: "789",
            xToken: "abc"
        ),
        onLogout: {}
    )
}
