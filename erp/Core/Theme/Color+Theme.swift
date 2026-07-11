import SwiftUI

extension Color {
    // Core semantic color tokens using the dynamic initializer
    static let appBackground = Color(
        light: Color(red: 0.97, green: 0.96, blue: 0.95),
        dark: Color(red: 0.05, green: 0.05, blue: 0.06)
    )

    static let cardBackground = Color(
        light: .white,
        dark: Color(red: 0.10, green: 0.11, blue: 0.14)
    )

    static let secondaryCard = Color(
        light: Color(red: 0.94, green: 0.93, blue: 0.91),
        dark: Color(red: 0.08, green: 0.10, blue: 0.13)
    )
    
    static let primaryText = Color(
        light: Color(red: 0.09, green: 0.09, blue: 0.15),
        dark: Color(red: 0.98, green: 0.98, blue: 0.98)
    )
    
    static let secondaryText = Color(
        light: Color(red: 0.45, green: 0.45, blue: 0.51),
        dark: Color(red: 0.63, green: 0.63, blue: 0.69)
    )
    
    static let accentGreen = Color(
        light: Color(red: 0.06, green: 0.73, blue: 0.51),
        dark: Color(red: 0.13, green: 0.77, blue: 0.37)
    )
    
    static let accentBlue = Color(
        light: Color(red: 0.15, green: 0.39, blue: 0.92),
        dark: Color(red: 0.23, green: 0.51, blue: 0.97)
    )
    
    static let accentOrange = Color(
        light: Color(red: 0.98, green: 0.45, blue: 0.09),
        dark: Color(red: 0.98, green: 0.45, blue: 0.09)
    )
    
    static let accentPurple = Color(
        light: Color(red: 0.55, green: 0.36, blue: 0.97),
        dark: Color(red: 0.66, green: 0.33, blue: 0.97)
    )
    
    static let dangerRed = Color(
        light: Color(red: 0.94, green: 0.27, blue: 0.27),
        dark: Color(red: 0.94, green: 0.27, blue: 0.27)
    )
    
    static let warningOrange = Color(
        light: Color(red: 0.98, green: 0.45, blue: 0.09),
        dark: Color(red: 0.98, green: 0.45, blue: 0.09)
    )
    
    static let successGreen = Color(
        light: Color(red: 0.06, green: 0.73, blue: 0.51),
        dark: Color(red: 0.13, green: 0.77, blue: 0.37)
    )
    
    static let divider = Color(
        light: Color.black.opacity(0.08),
        dark: Color.white.opacity(0.08)
    )
    
    static let shadow = Color(
        light: Color.black.opacity(0.05),
        dark: Color.black.opacity(0.25)
    )
    
    // Backward-compatibility aliases for pre-existing views
    static let appCard = cardBackground
    static let appSecondaryCard = secondaryCard
    static let appTextPrimary = primaryText
    static let appTextSecondary = secondaryText
    static let appTextTertiary = secondaryText
    static let appGreen = accentGreen
    static let appBlue = accentBlue
    static let appOrange = accentOrange
    static let appPurple = accentPurple
    static let appRed = dangerRed
    static let appTeal = Color(light: Color(red: 13/255, green: 148/255, blue: 136/255), dark: Color(red: 20/255, green: 184/255, blue: 166/255))
    static let appYellow = Color(light: Color(red: 202/255, green: 138/255, blue: 4/255), dark: Color(red: 234/255, green: 179/255, blue: 8/255))
}
