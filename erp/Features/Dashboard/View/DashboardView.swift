import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = AttendanceViewModel()
    let rollNumber: String
    let firstName: String
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Card
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Hello, \(firstName)")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text("Roll No: \(rollNumber)")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            Spacer()
                            
                            // Semester Picker
                            if !viewModel.semesters.isEmpty {
                                Menu {
                                    ForEach(viewModel.semesters) { sem in
                                        Button(sem.name) {
                                            Task {
                                                await viewModel.changeSemester(semesterId: sem.id)
                                            }
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 6) {
                                        Text("Semester \(viewModel.selectedSemesterId ?? 1)")
                                            .font(.system(size: 14, weight: .semibold))
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 10, weight: .bold))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 14)
                                    .background(Color.white.opacity(0.08))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                    )
                                }
                            }
                        }
                        
                        // Circular Progress view
                        ProgressRingView(
                            progress: viewModel.overallPercentage / 100.0,
                            text: String(format: "%.1f%%", viewModel.overallPercentage)
                        )
                        .padding(.top, 10)
                        
                        // Small Stats Row
                        HStack(spacing: 30) {
                            VStack(spacing: 2) {
                                Text("\(viewModel.presentLectures)")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                Text("Attended")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.white.opacity(0.4))
                            }
                            
                            Divider()
                                .frame(height: 24)
                                .background(Color.white.opacity(0.15))
                            
                            VStack(spacing: 2) {
                                Text("\(viewModel.totalLectures)")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                Text("Total classes")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.white.opacity(0.4))
                            }
                        }
                    }
                    .padding(24)
                    .background(Color.white.opacity(0.04))
                    .cornerRadius(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1.5)
                    )
                    .padding(.horizontal, 16)
                    
                    // Subject Cards List
                    VStack(spacing: 12) {
                        ForEach(Array(viewModel.subjectsGrouped.keys), id: \.self) { subjectName in
                            let entries = viewModel.subjectsGrouped[subjectName] ?? []
                            let total = entries.count
                            let present = entries.filter { !$0.isAbsent }.count
                            let percent = total > 0 ? (Double(present) / Double(total) * 100.0) : 0.0
                            
                            SubjectAttendanceTile(
                                subjectName: subjectName,
                                present: present,
                                total: total,
                                percent: percent,
                                groupedByDate: viewModel.groupByDate(entries: entries)
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 120) // spacing for bottom bar
                }
                .padding(.top, 16)
            }
            
            if case .loading = viewModel.state {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 46/255, green: 158/255, blue: 91/255)))
                    .scaleEffect(1.5)
            }
        }
        .onAppear {
            if viewModel.attendanceEntries.isEmpty {
                Task {
                    await viewModel.loadSemestersAndAttendance()
                }
            }
        }
    }
}

// Subject tile component with expandability
struct SubjectAttendanceTile: View {
    let subjectName: String
    let present: Int
    let total: Int
    let percent: Double
    let groupedByDate: [(date: String, status: String)]
    
    @State private var isExpanded = false
    
    private var isLow: Bool {
        return percent < 75.0
    }
    
    private var statusColor: Color {
        return isLow ? Color(red: 229/255, green: 57/255, blue: 53/255) : Color(red: 61/255, green: 170/255, blue: 112/255)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 0) {
                    // Status bar indicator
                    Rectangle()
                        .fill(statusColor)
                        .frame(width: 4)
                        .frame(maxHeight: .infinity)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(subjectName)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                        
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("ATTENDED")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(.white.opacity(0.4))
                                    .tracking(1)
                                
                                Text("\(present) / \(total)")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            
                            Text(String(format: "%.1f%%", percent))
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(statusColor)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                                .background(statusColor.opacity(0.1))
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(statusColor.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 16)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.3))
                        .rotationEffect(Angle(degrees: isExpanded ? 90 : 0))
                        .padding(.trailing, 16)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                Divider()
                    .background(Color.white.opacity(0.1))
                    .padding(.horizontal, 12)
                
                if groupedByDate.isEmpty {
                    Text("No records found")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.4))
                        .padding(16)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(groupedByDate, id: \.date) { item in
                            HStack {
                                Text(item.date)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                                Spacer()
                                
                                Text(item.status == "A" ? "Absent" : "Present")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(item.status == "A" ? Color(red: 229/255, green: 57/255, blue: 53/255) : Color(red: 61/255, green: 170/255, blue: 112/255))
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .background(Color.white.opacity(0.04))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.08), lineWidth: 1.5)
        )
    }
}
