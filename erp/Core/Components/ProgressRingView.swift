import SwiftUI

struct ProgressRingView: View {
    let progress: Double // Value between 0.0 and 1.0
    let text: String
    
    var body: some View {
        ZStack {
            // Track circle
            Circle()
                .stroke(Color.white.opacity(0.08), lineWidth: 16)
            
            // Progress circle with gradient
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(
                    LinearGradient(
                        colors: [Color(red: 46/255, green: 158/255, blue: 91/255), Color(red: 76/255, green: 175/255, blue: 80/255)],
                        startPoint: .topLeading,
                        endPoint: .bottomRight
                    ),
                    style: StrokeStyle(lineWidth: 16, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeOut(duration: 0.8), value: progress)
            
            // Text in center
            VStack(spacing: 2) {
                Text(text)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text("Overall")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.45))
                    .textCase(.uppercase)
            }
        }
        .frame(width: 170, height: 170)
    }
}

#Preview {
    ProgressRingView(progress: 0.784, text: "78.4%")
        .background(Color.black)
}
