import SwiftUI

extension Color {
    static var currentTheme: ThemeMode {
        let raw = UserDefaults.standard.string(forKey: "themeMode") ?? ""
        return ThemeMode(rawValue: raw) ?? .dark
    }

    // Core semantic color tokens resolving dynamically
    static var appBackground: Color {
        switch currentTheme {
        case .light:
            return Color(red: 0.97, green: 0.96, blue: 0.95)
        case .dark:
            return Color(red: 0.05, green: 0.05, blue: 0.06)
        case .tint:
            return Color(red: 0.94, green: 0.95, blue: 0.96) // Slightly tinted/blue-gray background
        }
    }

    static var cardBackground: Color {
        switch currentTheme {
        case .light, .tint:
            return .white
        case .dark:
            return Color(red: 0.10, green: 0.11, blue: 0.14)
        }
    }

    static var secondaryCard: Color {
        switch currentTheme {
        case .light, .tint:
            return Color(red: 0.94, green: 0.93, blue: 0.91)
        case .dark:
            return Color(red: 0.08, green: 0.10, blue: 0.13)
        }
    }
    
    static var primaryText: Color {
        switch currentTheme {
        case .light, .tint:
            return Color(red: 0.09, green: 0.09, blue: 0.15)
        case .dark:
            return Color(red: 0.98, green: 0.98, blue: 0.98)
        }
    }
    
    static var secondaryText: Color {
        switch currentTheme {
        case .light, .tint:
            return Color(red: 0.45, green: 0.45, blue: 0.51)
        case .dark:
            return Color(red: 0.63, green: 0.63, blue: 0.69)
        }
    }
    
    static var accentGreen: Color {
        switch currentTheme {
        case .light, .tint:
            return Color(red: 0.06, green: 0.73, blue: 0.51)
        case .dark:
            return Color(red: 0.13, green: 0.77, blue: 0.37)
        }
    }
    
    static var accentBlue: Color {
        switch currentTheme {
        case .light, .tint:
            return Color(red: 0.15, green: 0.39, blue: 0.92)
        case .dark:
            return Color(red: 0.23, green: 0.51, blue: 0.97)
        }
    }
    
    static var accentOrange: Color {
        return Color(red: 0.98, green: 0.45, blue: 0.09)
    }
    
    static var accentPurple: Color {
        switch currentTheme {
        case .light, .tint:
            return Color(red: 0.55, green: 0.36, blue: 0.97)
        case .dark:
            return Color(red: 0.66, green: 0.33, blue: 0.97)
        }
    }
    
    static var dangerRed: Color {
        return Color(red: 0.94, green: 0.27, blue: 0.27)
    }
    
    static var warningOrange: Color {
        return Color(red: 0.98, green: 0.45, blue: 0.09)
    }
    
    static var successGreen: Color {
        switch currentTheme {
        case .light, .tint:
            return Color(red: 0.06, green: 0.73, blue: 0.51)
        case .dark:
            return Color(red: 0.13, green: 0.77, blue: 0.37)
        }
    }
    
    static var divider: Color {
        switch currentTheme {
        case .light, .tint:
            return Color.black.opacity(0.08)
        case .dark:
            return Color.white.opacity(0.08)
        }
    }
    
    static var shadow: Color {
        switch currentTheme {
        case .light, .tint:
            return Color.black.opacity(0.05)
        case .dark:
            return Color.black.opacity(0.25)
        }
    }
    
    // Backward-compatibility aliases
    static var appCard: Color { cardBackground }
    static var appSecondaryCard: Color { secondaryCard }
    static var appTextPrimary: Color { primaryText }
    static var appTextSecondary: Color { secondaryText }
    static var appTextTertiary: Color { secondaryText }
    static var appGreen: Color { accentGreen }
    static var appBlue: Color { accentBlue }
    static var appOrange: Color { accentOrange }
    static var appPurple: Color { accentPurple }
    static var appRed: Color { dangerRed }
    
    static var appTeal: Color {
        switch currentTheme {
        case .light, .tint:
            return Color(red: 13/255, green: 148/255, blue: 136/255)
        case .dark:
            return Color(red: 20/255, green: 184/255, blue: 166/255)
        }
    }
    
    static var appYellow: Color {
        switch currentTheme {
        case .light, .tint:
            return Color(red: 202/255, green: 138/255, blue: 4/255)
        case .dark:
            return Color(red: 234/255, green: 179/255, blue: 8/255)
        }
    }
}
