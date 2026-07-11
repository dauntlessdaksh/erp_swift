import SwiftUI

struct AssignmentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header
                    HStack(spacing: 12) {
                        Image(systemName: "doc.text.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.appPurple)
                        
                        Text("Assignments")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundColor(.appTextPrimary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    
                    Spacer(minLength: 60)
                    
                    // Empty State Illustration Container
                    VStack(spacing: 28) {
                        ZStack {
                            Circle()
                                .fill(Color.appPurple.opacity(0.1))
                                .frame(width: 140, height: 140)
                            
                            Image(systemName: "doc.text.magnifyingglass")
                                .font(.system(size: 64))
                                .foregroundColor(.appPurple)
                                .shadow(color: Color.appPurple.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        
                        VStack(spacing: 8) {
                            Text("No Assignments Yet!")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.appTextPrimary)
                            
                            Text("Your coursework is currently up to date.\nEnjoy the free time! 🎉")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.appTextSecondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                        .padding(.horizontal, 32)
                        
                        // Purple Accent Button
                        Button(action: {
                            // Empty action for now
                        }) {
                            Text("Check Again")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 36)
                                .background(
                                    LinearGradient.purpleGradient
                                )
                                .cornerRadius(20)
                                .premiumCardShadow(colorScheme: colorScheme)
                        }
                        .buttonStyle(TactileButtonStyle())
                    }
                    .padding(32)
                    .background(Color.appCard)
                    .cornerRadius(32)
                    .innerHighlight(cornerRadius: 32, colorScheme: colorScheme)
                    .premiumCardShadow(colorScheme: colorScheme)
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
                .padding(.bottom, 160) // Prevent overlap with custom tab bar
            }
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    AssignmentView()
        .background(Color.black)
}
