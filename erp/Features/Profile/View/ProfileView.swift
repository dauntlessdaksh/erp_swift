import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    let onLogout: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @State private var showLogoutDialog = false
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header
                    HStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.appBlue)
                        
                        Text("Profile")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundColor(.appTextPrimary)
                        
                        Spacer()
                        
                        Button(action: {
                            showLogoutDialog = true
                        }) {
                            Image(systemName: "power")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.appRed)
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.appTextPrimary.opacity(0.08), lineWidth: 1)
                                )
                        }
                        .buttonStyle(TactileButtonStyle())
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    
                    switch viewModel.state {
                    case .initial, .loading:
                        Spacer(minLength: 100)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.appBlue))
                            .scaleEffect(1.5)
                        Spacer()
                        
                    case .error(let msg):
                        Spacer(minLength: 100)
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.appRed)
                            Text(msg)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.appTextSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        Spacer()
                        
                    case .loaded(let profile):
                        VStack(spacing: 20) {
                            // Section 1: Student Info
                            ProfileSectionCard(title: "Student Info", iconName: "person.text.rectangle.fill", accentColor: .appBlue) {
                                InfoRowView(label: "Full Name", value: profile.fullName)
                                InfoRowView(label: "Date of Birth", value: profile.dob)
                                InfoRowView(label: "Mobile No.", value: profile.contactNumber)
                                InfoRowView(label: "Home Address", value: profile.address)
                            }
                            
                            // Section 2: Academic Info
                            ProfileSectionCard(title: "Academic Info", iconName: "graduationcap.fill", accentColor: .appBlue) {
                                InfoRowView(label: "Roll Number", value: profile.rollNumber)
                                InfoRowView(label: "Semester", value: "Semester \(profile.semester)")
                                InfoRowView(label: "Section", value: profile.section)
                                InfoRowView(label: "College Email", value: profile.collegeEmail)
                            }
                            
                            // Section 3: Family Info
                            ProfileSectionCard(title: "Family Details", iconName: "person.2.fill", accentColor: .appBlue) {
                                InfoRowView(label: "Father's Name", value: profile.fatherName)
                                InfoRowView(label: "Mother's Name", value: profile.motherName)
                                InfoRowView(label: "Parent Mobile No.", value: profile.parentMobileNumber)
                            }
                            
                            // Glass Logout Button at the bottom
                            Button(action: {
                                showLogoutDialog = true
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "power")
                                        .font(.system(size: 16, weight: .bold))
                                    Text("Sign Out of Portal")
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                }
                                .foregroundColor(.appRed)
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity)
                                .background(.ultraThinMaterial)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.appRed.opacity(0.15), lineWidth: 1.5)
                                )
                                .premiumCardShadow(colorScheme: colorScheme)
                            }
                            .buttonStyle(TactileButtonStyle())
                            .padding(.top, 10)
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.bottom, 160) // Prevent overlap with custom tab bar
            }
            .scrollContentBackground(.hidden)
        }
        .onAppear {
            Task {
                await viewModel.loadProfile()
            }
        }
        .alert("Sign Out", isPresented: $showLogoutDialog) {
            Button("Cancel", role: .cancel) {}
            Button("Sign Out", role: .destructive) {
                onLogout()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
}

struct ProfileSectionCard<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let iconName: String
    let accentColor: Color
    let content: Content
    
    init(title: String, iconName: String, accentColor: Color = .appBlue, @ViewBuilder content: () -> Content) {
        self.title = title
        self.iconName = iconName
        self.accentColor = accentColor
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: iconName)
                    .foregroundColor(accentColor)
                    .font(.system(size: 16, weight: .bold))
                
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.appTextPrimary)
            }
            
            Divider()
                .background(Color.appSecondaryCard)
            
            VStack(alignment: .leading, spacing: 14) {
                content
            }
            .padding(.top, 4)
        }
        .padding(20)
        .background(Color.appCard)
        .cornerRadius(28)
        .innerHighlight(cornerRadius: 28, colorScheme: colorScheme)
        .premiumCardShadow(colorScheme: colorScheme)
    }
}

struct InfoRowView: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(.system(size: 9, weight: .black, design: .rounded))
                .foregroundColor(.appTextSecondary.opacity(0.6))
                .tracking(1.2)
            
            Text(value.isEmpty ? "-" : value)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(.appTextPrimary)
                .multilineTextAlignment(.leading)
        }
    }
}
