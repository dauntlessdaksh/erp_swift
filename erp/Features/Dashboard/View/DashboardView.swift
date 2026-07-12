import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = AttendanceViewModel()
    @Environment(\.colorScheme) var colorScheme
    let rollNumber: String
    let firstName: String
    
    private var displayRollNumber: String {
        if rollNumber.hasSuffix("194") {
            return String(rollNumber.dropLast(3))
        }
        return rollNumber
    }
    
    private var heroGradient: LinearGradient {
        if Color.currentTheme == .light {
            return LinearGradient(
                colors: [Color.appGreen.opacity(0.16), Color.appTeal.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [Color(red: 4/255, green: 65/255, blue: 45/255), Color(red: 1/255, green: 30/255, blue: 20/255)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // Welcome & Semester Header
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hello, \(viewModel.studentName)")
                                .font(.system(size: 28, weight: .black, design: .rounded))
                                .foregroundColor(.appTextPrimary)
                            
                            Text("Student Number: \(displayRollNumber)")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(.appTextSecondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 8) {
                            ThemeSwitcher()
                            
                            if !viewModel.semesters.isEmpty {
                                SemesterPicker(
                                    semesters: viewModel.semesters,
                                    selectedSemesterId: viewModel.selectedSemesterId,
                                    onSelect: { semId in
                                        Task {
                                            await viewModel.changeSemester(semesterId: semId)
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    
                    // Hero Card (Large Attendance Ring with custom styling)
                    HStack(spacing: 12) {
                        ProgressRingView(
                            progress: viewModel.overallPercentage / 100.0,
                            text: String(format: "%.1f%%", viewModel.overallPercentage),
                            ringColor: Color.currentTheme == .light ? Color.appGreen : .white,
                            ringTrackColor: Color.currentTheme == .light ? Color.appGreen.opacity(0.08) : Color.white.opacity(0.08),
                            textColor: Color.currentTheme == .light ? Color.appTextPrimary : .white,
                            labelColor: Color.currentTheme == .light ? Color.appTextSecondary : .white.opacity(0.7)
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Overall Attendance")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(Color.currentTheme == .light ? Color.appTextPrimary : .white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                            
                            Text("\(viewModel.presentLectures) of \(viewModel.totalLectures) classes")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(Color.currentTheme == .light ? Color.appTextSecondary : .white.opacity(0.8))
                            
                            let statusText = viewModel.overallPercentage >= 75.0 ? "On Track" : "Action Needed"
                            let statusColor = viewModel.overallPercentage >= 75.0 ? Color.appGreen : Color.appRed
                            
                            Text(statusText)
                                .font(.system(size: 11, weight: .black, design: .rounded))
                                .textCase(.uppercase)
                                .foregroundColor(statusColor)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(statusColor.opacity(0.12))
                                .cornerRadius(8)
                        }
                        
                        Spacer()
                    }
                    .padding(24)
                    .background(heroGradient)
                    .cornerRadius(30)
                    .innerHighlight(cornerRadius: 30, colorScheme: colorScheme)
                    .premiumCardShadow(colorScheme: colorScheme)
                    .padding(.horizontal, 24)
                    
                    // 4 Core Stat Tiles (Bento Grid)
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                        StatTile(
                            title: "Present",
                            value: "\(viewModel.presentLectures)",
                            subtitle: "Lectures",
                            iconName: "checkmark.circle.fill",
                            backgroundGradient: .greenGradient
                        )
                        
                        StatTile(
                            title: "Absent",
                            value: "\(viewModel.totalLectures - viewModel.presentLectures)",
                            subtitle: "Lectures",
                            iconName: "xmark.circle.fill",
                            backgroundGradient: .coralGradient
                        )
                        
                        StatTile(
                            title: "Leaves",
                            value: "\(viewModel.leavesAllowed)",
                            subtitle: "Allowed",
                            iconName: "calendar.badge.exclamationmark",
                            backgroundGradient: .orangeGradient
                        )
                        
                        StatTile(
                            title: "Required %",
                            value: "75%",
                            subtitle: "Target Goal",
                            iconName: "target",
                            backgroundGradient: .blueGradient
                        )
                    }
                    .padding(.horizontal, 24)
                    
                    // Subjects Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Subjects")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.appTextPrimary)
                            .padding(.horizontal, 24)
                        
                        LazyVStack(spacing: 16) {
                            ForEach(Array(viewModel.subjectsGrouped.keys), id: \.self) { subjectName in
                                let entries = viewModel.subjectsGrouped[subjectName] ?? []
                                let total = entries.count
                                let present = entries.filter { !$0.isAbsent }.count
                                let percent = total > 0 ? (Double(present) / Double(total) * 100.0) : 0.0
                                
                                SubjectTile(
                                    subjectName: subjectName,
                                    present: present,
                                    total: total,
                                    percent: percent,
                                    groupedByDate: viewModel.groupByDate(entries: entries)
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 140) // space for custom tab bar
                }
                .padding(.top, 8)
            }
            .scrollContentBackground(.hidden)
            
            if case .loading = viewModel.state {
                Color.black.opacity(0.15)
                    .ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.appGreen))
                    .scaleEffect(1.5)
            }
        }
        .onAppear {
            Task {
                if viewModel.attendanceEntries.isEmpty {
                    await viewModel.loadSemestersAndAttendance()
                }
                await viewModel.loadStudentProfile()
            }
        }
    }
}
