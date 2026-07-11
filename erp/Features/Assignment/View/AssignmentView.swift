import SwiftUI

struct AssignmentView: View {
    var body: some View {
        ZStack {
            VStack {
                // Header
                HStack {
                    Text("Assignments")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer()
                
                // Content
                VStack(spacing: 16) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 64))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("No Assignments Yet!")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Enjoy the free time 🎉")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                }
                
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
    }
}

#Preview {
    AssignmentView()
        .background(Color.black)
}
