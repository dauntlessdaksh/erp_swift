import SwiftUI

struct TransportAttendanceView: View {
    @StateObject private var viewModel = TransportAttendanceViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header
                    HStack(spacing: 12) {
                        Image(systemName: "cpu.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.appGreen)
                        
                        Text("Technical Training")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundColor(.appTextPrimary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    
                    switch viewModel.state {
                    case .initial, .loading:
                        Spacer(minLength: 100)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.appGreen))
                            .scaleEffect(1.5)
                        Spacer()
                        
                    case .error(let msg):
                        Spacer(minLength: 100)
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.appRed)
                            Text(msg)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.appTextSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        Spacer()
                        
                    case .loaded(let list):
                        if list.isEmpty {
                            Spacer(minLength: 100)
                            VStack(spacing: 16) {
                                Image(systemName: "calendar.badge.exclamationmark")
                                    .font(.system(size: 64))
                                    .foregroundColor(.appTextSecondary.opacity(0.3))
                                Text("No training attendance found")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.appTextSecondary)
                            }
                            Spacer()
                        } else {
                            let total = list.count
                            let present = list.filter { !$0.isInAbsent }.count
                            let percent = total > 0 ? (Double(present) / Double(total) * 100.0) : 0.0
                            let isGood = percent >= 80.0
                            let statusColor = isGood ? Color.appGreen : Color.appRed
                            
                            // Overall Progress Ring Card
                            HStack(spacing: 24) {
                                ProgressRingView(
                                    progress: percent / 100.0,
                                    text: String(format: "%.1f%%", percent),
                                    ringColor: colorScheme == .light ? Color.appGreen : .white,
                                    ringTrackColor: colorScheme == .light ? Color.appGreen.opacity(0.08) : Color.white.opacity(0.08),
                                    textColor: colorScheme == .light ? Color.appTextPrimary : .white,
                                    labelColor: colorScheme == .light ? Color.appTextSecondary : .white.opacity(0.7)
                                )
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Overall Attendance")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundColor(colorScheme == .light ? Color.appTextPrimary : .white)
                                    
                                    Text("\(present) of \(total) training days")
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(colorScheme == .light ? Color.appTextSecondary : .white.opacity(0.8))
                                    
                                    Text(isGood ? "GOOD STANDING" : "ATTENTION REQUIRED")
                                        .font(.system(size: 10, weight: .black, design: .rounded))
                                        .foregroundColor(statusColor)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 8)
                                        .background(statusColor.opacity(0.12))
                                        .cornerRadius(6)
                                }
                                
                                Spacer()
                            }
                            .padding(24)
                            .background(
                                ZStack {
                                    if colorScheme == .light {
                                        LinearGradient(
                                            colors: [Color.appGreen.opacity(0.16), Color.appTeal.opacity(0.10)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    } else {
                                        LinearGradient(
                                            colors: [Color(red: 4/255, green: 65/255, blue: 45/255), Color(red: 1/255, green: 30/255, blue: 20/255)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    }
                                }
                            )
                            .cornerRadius(32)
                            .innerHighlight(cornerRadius: 32, colorScheme: colorScheme)
                            .premiumCardShadow(colorScheme: colorScheme)
                            .padding(.horizontal, 24)
                            
                            // Timeline logs section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Training History Log")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.appTextPrimary)
                                    .padding(.horizontal, 24)
                                
                                LazyVStack(spacing: 12) {
                                    ForEach(list) { entry in
                                        HStack(spacing: 16) {
                                            Circle()
                                                .fill(entry.isInAbsent ? Color.appRed : Color.appGreen)
                                                .frame(width: 8, height: 8)
                                                .shadow(color: (entry.isInAbsent ? Color.appRed : Color.appGreen).opacity(0.4), radius: 4)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(formatDate(entry.attendanceDate))
                                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                                    .foregroundColor(.appTextPrimary)
                                            }
                                            
                                            Spacer()
                                            
                                            Text(entry.isInAbsent ? "Absent" : "Present")
                                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                                .foregroundColor(entry.isInAbsent ? Color.appRed : Color.appGreen)
                                                .padding(.vertical, 4)
                                                .padding(.horizontal, 10)
                                                .background((entry.isInAbsent ? Color.appRed : Color.appGreen).opacity(0.08))
                                                .cornerRadius(10)
                                        }
                                        .padding(18)
                                        .background(Color.appCard)
                                        .cornerRadius(24)
                                        .innerHighlight(cornerRadius: 24, colorScheme: colorScheme)
                                        .premiumCardShadow(colorScheme: colorScheme)
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                    }
                }
                .padding(.bottom, 160) // Prevent overlap with custom tab bar
            }
            .scrollContentBackground(.hidden)
        }
        .onAppear {
            Task {
                await viewModel.loadAttendance()
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    TransportAttendanceView()
        .background(Color.black)
}
