import SwiftUI

extension Color {
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return UIColor(light)
            case .dark:
                return UIColor(dark)
            @unknown default:
                return UIColor(dark)
            }
        })
    }
}

extension LinearGradient {
    static let greenGradient = LinearGradient(
        colors: [Color.accentGreen, Color(red: 5/255, green: 150/255, blue: 105/255)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let coralGradient = LinearGradient(
        colors: [Color.dangerRed, Color(red: 244/255, green: 63/255, blue: 94/255)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let orangeGradient = LinearGradient(
        colors: [Color.accentOrange, Color(red: 245/255, green: 158/255, blue: 11/255)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let blueGradient = LinearGradient(
        colors: [Color.accentBlue, Color(red: 6/255, green: 182/255, blue: 212/255)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let purpleGradient = LinearGradient(
        colors: [Color.accentPurple, Color(red: 217/255, green: 70/255, blue: 239/255)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct TactileButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.90 : 1.0)
            .animation(.spring(response: 0.15, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

extension View {
    func premiumCardShadow(colorScheme: ColorScheme) -> some View {
        self.shadow(
            color: colorScheme == .light ? Color.black.opacity(0.04) : Color.black.opacity(0.4),
            radius: 16,
            x: 0,
            y: 6
        )
    }
    
    func innerHighlight(cornerRadius: CGFloat, colorScheme: ColorScheme) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(colorScheme == .light ? 0.6 : 0.15),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1.5
                )
        )
    }
}

enum ThemeMode: String, CaseIterable, Identifiable {
    case light = "Light"
    case dark = "Dark"
    case tint = "Tint"
    
    var id: String { self.rawValue }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .tint: return .light
        }
    }
}
