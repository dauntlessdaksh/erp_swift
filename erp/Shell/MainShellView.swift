import SwiftUI

struct MainShellView: View {
    @State private var selectedTab = 0
    let loginResponse: LoginResponse
    let onLogout: () -> Void
    
    var body: some View {
        ZStack {
            // Dark slate background matching splash & login
            LinearGradient(
                colors: [Color(red: 2/255, green: 6/255, blue: 23/255), Color(red: 15/255, green: 23/255, blue: 42/255)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Subtle glowing circle for background visual depth
            VStack {
                HStack {
                    Circle()
                        .fill(Color(red: 99/255, green: 102/255, blue: 241/255).opacity(0.08))
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
                switch selectedTab {
                case 0:
                    DashboardView(
                        rollNumber: loginResponse.xUserId,
                        firstName: "Student"
                    )
                case 1:
                    IdentityView()
                case 2:
                    AssignmentView()
                case 3:
                    TransportAttendanceView()
                case 4:
                    ProfileView(onLogout: onLogout)
                default:
                    DashboardView(
                        rollNumber: loginResponse.xUserId,
                        firstName: "Student"
                    )
                }
            }
            
            // Custom floating tab bar at the bottom
            VStack {
                Spacer()
                
                HStack(spacing: 20) {
                    TabBarItem(iconName: "grid", isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }
                    TabBarItem(iconName: "cardtext", isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }
                    TabBarItem(iconName: "doc.text", isSelected: selectedTab == 2) {
                        selectedTab = 2
                    }
                    TabBarItem(iconName: "cpu", isSelected: selectedTab == 3) {
                        selectedTab = 3
                    }
                    TabBarItem(iconName: "person", isSelected: selectedTab == 4) {
                        selectedTab = 4
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(
                    Color.white.opacity(0.07)
                        .blur(radius: 0.5)
                )
                .cornerRadius(32)
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1.5)
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
                .shadow(color: Color.black.opacity(0.35), radius: 25, x: 0, y: 10)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

struct TabBarItem: View {
    let iconName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isSelected ? "\(iconName).fill" : iconName)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? .white : .white.opacity(0.35))
                .padding(12)
                .background(isSelected ? Color.white.opacity(0.12) : Color.clear)
                .cornerRadius(16)
                .scaleEffect(isSelected ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        }
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
