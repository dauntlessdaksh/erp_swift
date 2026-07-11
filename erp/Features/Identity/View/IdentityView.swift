import SwiftUI

struct IdentityView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var barcodeData: String?
    @State private var studentName: String = "Student"
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header
                    HStack(spacing: 12) {
                        Image(systemName: "person.text.rectangle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.appOrange)
                        
                        Text("Identity Card")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundColor(.appTextPrimary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    
                    Spacer(minLength: 20)
                    
                    // Premium Floating Glass Student ID Card
                    VStack(spacing: 24) {
                        // Logo & School Header
                        HStack(spacing: 12) {
                            Image(systemName: "graduationcap.circle.fill")
                                .font(.system(size: 36))
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("UNIVERSITY PORTAL")
                                    .font(.system(size: 14, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                                    .tracking(1.5)
                                
                                Text("UpMark ERP Verified")
                                    .font(.system(size: 10, weight: .bold, design: .rounded))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            Spacer()
                        }
                        
                        // Student Basic Details Row
                        HStack(alignment: .top, spacing: 16) {
                            VStack(alignment: .leading, spacing: 12) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("STUDENT NAME")
                                        .font(.system(size: 9, weight: .black))
                                        .foregroundColor(.white.opacity(0.6))
                                    Text(studentName)
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("DEPARTMENT")
                                        .font(.system(size: 9, weight: .black))
                                        .foregroundColor(.white.opacity(0.6))
                                    Text("Computer Science")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 12) {
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("STUDENT ID")
                                        .font(.system(size: 9, weight: .black))
                                        .foregroundColor(.white.opacity(0.6))
                                    Text(barcodeData ?? "Loading...")
                                        .font(.system(size: 15, weight: .bold, design: .monospaced))
                                        .foregroundColor(.white)
                                }
                                
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("STATUS")
                                        .font(.system(size: 9, weight: .black))
                                        .foregroundColor(.white.opacity(0.6))
                                    Text("Active")
                                        .font(.system(size: 12, weight: .bold, design: .rounded))
                                        .foregroundColor(.appGreen)
                                        .padding(.vertical, 2)
                                        .padding(.horizontal, 8)
                                        .background(Color.white)
                                        .cornerRadius(6)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        
                        // Barcode Container
                        if let code = barcodeData {
                            VStack(spacing: 12) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white)
                                    
                                    if let img = BarcodeGenerator.generateBarcode(from: code) {
                                        Image(uiImage: img)
                                            .resizable()
                                            .interpolation(.none)
                                            .aspectRatio(contentMode: .fit)
                                            .padding(.horizontal, 24)
                                            .padding(.vertical, 16)
                                    } else {
                                        Text("Barcode Error")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.appRed)
                                    }
                                }
                                .frame(height: 100)
                                
                                Text(code)
                                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                                    .foregroundColor(.white.opacity(0.7))
                                    .tracking(3)
                            }
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                    }
                    .padding(24)
                    .background(
                        LinearGradient(
                            colors: [Color.appOrange, Color(red: 251/255, green: 146/255, blue: 60/255)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(32)
                    .innerHighlight(cornerRadius: 32, colorScheme: colorScheme)
                    .premiumCardShadow(colorScheme: colorScheme)
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                    
                    // Card instruction text
                    HStack(spacing: 8) {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.appOrange)
                        Text("Scan this card at transport gates or library kiosks.")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(.appTextSecondary)
                    }
                    .padding(.horizontal, 32)
                    .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                .padding(.bottom, 160) // Prevent overlap with custom tab bar
            }
            .scrollContentBackground(.hidden)
        }
        .onAppear {
            loadBarcodeData()
            loadStudentName()
        }
    }
    
    private func loadBarcodeData() {
        if let username = KeychainHelper.shared.read(forKey: "stored_username") {
            if username.count > 3 {
                self.barcodeData = String(username.prefix(username.count - 3))
            } else {
                self.barcodeData = username
            }
        }
    }
    
    private func loadStudentName() {
        Task {
            do {
                let profile = try await ProfileRepository().fetchUserProfile()
                self.studentName = profile.fullName.uppercased()
            } catch {
                // Keep default
            }
        }
    }
}

#Preview {
    IdentityView()
        .background(Color.black)
}
