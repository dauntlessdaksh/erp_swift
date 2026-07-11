import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    let onLogout: () -> Void
    
    @State private var showLogoutDialog = false
    
    var body: some View {
        ZStack {
            VStack {
                // Header
                HStack {
                    Text("Profile")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                    
                    Button(action: {
                        showLogoutDialog = true
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(red: 255/255, green: 107/255, blue: 107/255))
                            .padding(10)
                            .background(Color(red: 255/255, green: 107/255, blue: 107/255).opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                switch viewModel.state {
                case .initial, .loading:
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 46/255, green: 158/255, blue: 91/255)))
                        .scaleEffect(1.5)
                    Spacer()
                    
                case .error(let msg):
                    Spacer()
                    Text(msg)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    Spacer()
                    
                case .loaded(let profile):
                    ScrollView {
                        VStack(spacing: 20) {
                            // Section 1: Academic & Personal Info
                            ProfileSectionCard(title: "Academic Profile", iconName: "book.fill") {
                                InfoRowView(label: "Full Name", value: profile.fullName)
                                InfoRowView(label: "Email", value: profile.collegeEmail)
                                InfoRowView(label: "Roll Number", value: profile.rollNumber)
                                InfoRowView(label: "Semester", value: "Semester \(profile.semester)")
                                InfoRowView(label: "Section", value: profile.section)
                                InfoRowView(label: "Date of Birth", value: profile.dob)
                                InfoRowView(label: "Mobile No.", value: profile.contactNumber)
                            }
                            
                            // Section 2: Family Info
                            ProfileSectionCard(title: "Family Details", iconName: "person.2.fill") {
                                InfoRowView(label: "Father's Name", value: profile.fatherName)
                                InfoRowView(label: "Mother's Name", value: profile.motherName)
                                InfoRowView(label: "Parent Mobile No.", value: profile.parentMobileNumber)
                            }
                            
                            // Section 3: Address Info
                            ProfileSectionCard(title: "Address", iconName: "mappin.and.ellipse") {
                                InfoRowView(label: "Home Address", value: profile.address)
                            }
                            
                            Spacer()
                                .frame(height: 120)
                        }
                        .padding(.top, 10)
                        .padding(.horizontal, 16)
                    }
                }
            }
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
    let title: String
    let iconName: String
    let content: Content
    
    init(title: String, iconName: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.iconName = iconName
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: iconName)
                    .foregroundColor(Color(red: 123/255, green: 111/255, blue: 240/255))
                    .font(.system(size: 16, weight: .bold))
                
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Divider()
                .background(Color.white.opacity(0.12))
            
            VStack(alignment: .leading, spacing: 14) {
                content
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color.white.opacity(0.04))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.08), lineWidth: 1.5)
        )
    }
}

struct InfoRowView: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.white.opacity(0.4))
                .tracking(1.2)
            
            Text(value.isEmpty ? "-" : value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
        }
    }
}
