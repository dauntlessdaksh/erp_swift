import SwiftUI

// PercentageBadge: Floating capsule adapting color based on attendance thresholds
struct PercentageBadge: View {
    let percent: Double
    
    private var colorScheme: (text: Color, bg: Color) {
        if percent >= 95.0 {
            return (Color.appGreen, Color.appGreen.opacity(0.12))
        } else if percent >= 80.0 {
            return (Color.appBlue, Color.appBlue.opacity(0.12))
        } else if percent >= 75.0 {
            return (Color.appOrange, Color.appOrange.opacity(0.12))
        } else {
            return (Color.appRed, Color.appRed.opacity(0.12))
        }
    }
    
    var body: some View {
        Text(String(format: "%.1f%%", percent))
            .font(.system(size: 13, weight: .bold, design: .rounded))
            .foregroundColor(colorScheme.text)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(colorScheme.bg)
            .cornerRadius(20)
    }
}

// ProgressCapsule: Custom progress indicator with gradient and shadow
struct ProgressCapsule: View {
    let progress: Double
    let gradient: LinearGradient
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.appSecondaryCard.opacity(0.4))
                    .frame(height: 10)
                
                Capsule()
                    .fill(gradient)
                    .frame(width: geo.size.width * CGFloat(min(progress, 1.0)), height: 10)
                    .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)
                    .animation(.spring(response: 0.55, dampingFraction: 0.8), value: progress)
            }
        }
        .frame(height: 10)
    }
}

// StatTile: Apple Fitness bento-style card supporting rich gradients or neutral backgrounds
struct StatTile: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let value: String
    let subtitle: String?
    let iconName: String
    let backgroundGradient: LinearGradient?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: iconName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(backgroundGradient == nil ? Color.appTextPrimary : .white)
                    .padding(10)
                    .background(backgroundGradient == nil ? Color.appSecondaryCard : Color.white.opacity(0.2))
                    .clipShape(Circle())
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(backgroundGradient == nil ? .appTextPrimary : .white)
                
                Text(title)
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .foregroundColor(backgroundGradient == nil ? .appTextSecondary : .white.opacity(0.8))
                    .textCase(.uppercase)
                    .tracking(0.8)
                
                if let sub = subtitle {
                    Text(sub)
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(backgroundGradient == nil ? .appTextTertiary : .white.opacity(0.6))
                        .padding(.top, 2)
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                if let gradient = backgroundGradient {
                    gradient
                } else {
                    Color.appCard
                }
            }
        )
        .cornerRadius(28)
        .innerHighlight(cornerRadius: 28, colorScheme: colorScheme)
        .premiumCardShadow(colorScheme: colorScheme)
    }
}

// AttendanceTimeline: Horizontal status circles for single/multiple classes per day
struct AttendanceTimeline: View {
    let groupedByDate: [(date: String, status: String)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(groupedByDate, id: \.date) { item in
                HStack(spacing: 12) {
                    Text(item.date)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.appTextPrimary)
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        ForEach(Array(item.status.enumerated()), id: \.offset) { _, char in
                            let isAbsent = char == "A"
                            let color = isAbsent ? Color.appRed : Color.appGreen
                            
                            Text(String(char))
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(color)
                                .frame(width: 28, height: 28)
                                .background(color.opacity(0.08))
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(color.opacity(0.35), lineWidth: 1)
                                )
                        }
                    }
                }
                .transition(.opacity.combined(with: .slide))
            }
        }
    }
}

// SemesterPicker: Minimal glassmorphic floating dropdown pill
struct SemesterPicker: View {
    @Environment(\.colorScheme) var colorScheme
    let semesters: [Semester]
    let selectedSemesterId: Int?
    let onSelect: (Int) -> Void
    
    var body: some View {
        Menu {
            ForEach(semesters) { sem in
                Button(sem.name) {
                    onSelect(sem.id)
                }
            }
        } label: {
            HStack(spacing: 6) {
                Text("Semester \(selectedSemesterId ?? 1)")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .black))
            }
            .foregroundColor(.appTextPrimary)
            .padding(.vertical, 8)
            .padding(.horizontal, 14)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.appTextPrimary.opacity(0.08), lineWidth: 1)
            )
            .premiumCardShadow(colorScheme: colorScheme)
        }
    }
}

// SubjectTile: Modern expandable card with custom progress gradient
struct SubjectTile: View {
    @Environment(\.colorScheme) var colorScheme
    let subjectName: String
    let present: Int
    let total: Int
    let percent: Double
    let groupedByDate: [(date: String, status: String)]
    
    @State private var isExpanded = false
    
    private var progressGradient: LinearGradient {
        if percent >= 95.0 {
            return .greenGradient
        } else if percent >= 80.0 {
            return .blueGradient
        } else if percent >= 75.0 {
            return .orangeGradient
        } else {
            return .coralGradient
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.78)) {
                    isExpanded.toggle()
                }
            }) {
                VStack(spacing: 14) {
                    HStack(alignment: .top, spacing: 12) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(subjectName)
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(.appTextPrimary)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                            
                            Text("\(present) of \(total) lectures")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundColor(.appTextSecondary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            PercentageBadge(percent: percent)
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.appTextSecondary.opacity(0.6))
                                .rotationEffect(Angle(degrees: isExpanded ? 90 : 0))
                        }
                    }
                    
                    ProgressCapsule(progress: total > 0 ? Double(present) / Double(total) : 0.0, gradient: progressGradient)
                        .padding(.top, 2)
                }
                .padding(20)
            }
            .buttonStyle(TactileButtonStyle())
            
            if isExpanded {
                VStack(spacing: 0) {
                    Divider()
                        .background(Color.appSecondaryCard)
                        .padding(.horizontal, 20)
                    
                    if groupedByDate.isEmpty {
                        Text("No attendance logs found")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(.appTextSecondary.opacity(0.6))
                            .padding(.vertical, 20)
                    } else {
                        AttendanceTimeline(groupedByDate: groupedByDate)
                            .padding(20)
                    }
                }
                .background(Color.appSecondaryCard.opacity(colorScheme == .dark ? 0.25 : 0.45))
            }
        }
        .background(Color.appCard)
        .cornerRadius(28)
        .innerHighlight(cornerRadius: 28, colorScheme: colorScheme)
        .premiumCardShadow(colorScheme: colorScheme)
    }
}

struct ThemeSwitcher: View {
    @AppStorage("themeMode") private var themeModeRaw = ThemeMode.dark.rawValue
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(ThemeMode.allCases) { mode in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        themeModeRaw = mode.rawValue
                    }
                }) {
                    Group {
                        if mode == .light {
                            Image(systemName: "sun.max.fill")
                        } else if mode == .dark {
                            Image(systemName: "moon.fill")
                        } else {
                            Image(systemName: "paintpalette.fill")
                        }
                    }
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(themeModeRaw == mode.rawValue ? .appTextPrimary : .appTextSecondary.opacity(0.6))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        ZStack {
                            if themeModeRaw == mode.rawValue {
                                Capsule()
                                    .fill(Color.appSecondaryCard)
                            }
                        }
                    )
                }
            }
        }
        .padding(3)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .overlay(
            Capsule()
                .stroke(Color.appTextPrimary.opacity(0.08), lineWidth: 1)
        )
    }
}
