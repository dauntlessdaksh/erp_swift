import SwiftUI

struct ProgressRingView: View {
    @Environment(\.colorScheme) var colorScheme
    let progress: Double // Value between 0.0 and 1.0
    let text: String
    
    var ringColor: Color = .appGreen
    var ringTrackColor: Color = .appSecondaryCard
    var textColor: Color = .appTextPrimary
    var labelColor: Color = .appTextSecondary
    
    var body: some View {
        ZStack {
            // Track circle
            Circle()
                .stroke(ringTrackColor, lineWidth: 16)
            
            // Progress circle with gradient
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(
                    LinearGradient(
                        colors: [ringColor, ringColor.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 16, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(Angle(degrees: -90))
                .animation(.spring(response: 0.8, dampingFraction: 0.7), value: progress)
            
            // Text in center
            VStack(spacing: 2) {
                Text(text)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(textColor)
                Text("Overall")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(labelColor)
                    .textCase(.uppercase)
                    .tracking(1.0)
            }
        }
        .frame(width: 135, height: 135)
    }
}

#Preview {
    ProgressRingView(progress: 0.784, text: "78.4%")
        .background(Color.black)
}
