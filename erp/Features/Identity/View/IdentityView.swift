import SwiftUI

struct IdentityView: View {
    @State private var barcodeData: String?
    
    var body: some View {
        ZStack {
            VStack {
                // Header
                HStack {
                    Text("E-Identity")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer(minLength: 40)
                
                // Barcode Card
                VStack(spacing: 24) {
                    Text("STUDENT ID")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.45))
                        .letterSpacing(1.5)
                    
                    if let code = barcodeData {
                        VStack(spacing: 16) {
                            // Barcode container
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                
                                if let img = BarcodeGenerator.generateBarcode(from: code) {
                                    Image(uiImage: img)
                                        .resizable()
                                        .interpolation(.none)
                                        .aspectRatio(contentMode: .fit)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 16)
                                } else {
                                    Text("Error generating barcode")
                                        .font(.system(size: 12))
                                        .foregroundColor(.red)
                                }
                            }
                            .frame(height: 110)
                            
                            Text(code)
                                .font(.system(size: 14, weight: .medium, design: .monospaced))
                                .foregroundColor(.white.opacity(0.65))
                                .letterSpacing(2)
                        }
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                }
                .padding(24)
                .background(Color.white.opacity(0.04))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1.5)
                )
                .padding(.horizontal, 32)
                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                
                Spacer()
                
                // Footer
                Text("UpMark ERP")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.25))
                    .letterSpacing(2)
                    .textCase(.uppercase)
                    .padding(.bottom, 120)
            }
        }
        .onAppear {
            loadBarcodeData()
        }
    }
    
    private func loadBarcodeData() {
        if let username = KeychainHelper.shared.read(forKey: "stored_username") {
            if username.count > 3 {
                // Remove last 3 characters as done in Flutter app
                self.barcodeData = String(username.prefix(username.count - 3))
            } else {
                self.barcodeData = username
            }
        }
    }
}

#Preview {
    IdentityView()
        .background(Color.black)
}
