import SwiftUI

struct TransportAttendanceView: View {
    @StateObject private var viewModel = TransportAttendanceViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                // Header
                HStack {
                    Text("Technical Training")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer(minLength: 10)
                
                switch viewModel.state {
                case .initial, .loading:
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 46/255, green: 158/255, blue: 91/255)))
                        .scaleEffect(1.5)
                    Spacer()
                    
                case .error(let msg):
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 40))
                            .foregroundColor(.red.opacity(0.8))
                        Text(msg)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    Spacer()
                    
                case .loaded(let list):
                    if list.isEmpty {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "calendar.badge.exclamationmark")
                                .font(.system(size: 54))
                                .foregroundColor(.white.opacity(0.2))
                            Text("No attendance found")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.4))
                        }
                        Spacer()
                    } else {
                        let total = list.count
                        let present = list.filter { !$0.isInAbsent }.count
                        let percent = total > 0 ? (Double(present) / Double(total) * 100.0) : 0.0
                        let isGood = percent >= 80.0
                        
                        ScrollView {
                            VStack(spacing: 20) {
                                // Summary Card
                                VStack(spacing: 16) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(String(format: "%.1f%%", percent))
                                                .font(.system(size: 36, weight: .black, design: .rounded))
                                                .foregroundColor(isGood ? Color(red: 61/255, green: 170/255, blue: 112/255) : Color(red: 229/255, green: 57/255, blue: 53/255))
                                            Text("TOTAL ATTENDANCE")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.white.opacity(0.4))
                                                .tracking(1)
                                        }
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 4) {
                                            Text("\(present) / \(total)")
                                                .font(.system(size: 18, weight: .bold))
                                                .foregroundColor(.white)
                                            Text(isGood ? "Good Attendance" : "Low Attendance")
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(isGood ? Color(red: 61/255, green: 170/255, blue: 112/255).opacity(0.8) : Color(red: 229/255, green: 57/255, blue: 53/255).opacity(0.8))
                                        }
                                    }
                                }
                                .padding(20)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1.5)
                                )
                                .padding(.horizontal, 16)
                                
                                // Logs List
                                VStack(spacing: 10) {
                                    ForEach(list) { entry in
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(formatDate(entry.attendanceDate))
                                                    .font(.system(size: 15, weight: .semibold))
                                                    .foregroundColor(.white)
                                                if let remarks = entry.remarks, !remarks.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                                    Text(remarks)
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.white.opacity(0.4))
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            Text(entry.isInAbsent ? "Absent" : "Present")
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundColor(entry.isInAbsent ? Color(red: 229/255, green: 57/255, blue: 53/255) : Color(red: 61/255, green: 170/255, blue: 112/255))
                                                .padding(.vertical, 4)
                                                .padding(.horizontal, 10)
                                                .background(entry.isInAbsent ? Color(red: 229/255, green: 57/255, blue: 53/255).opacity(0.1) : Color(red: 61/255, green: 170/255, blue: 112/255).opacity(0.1))
                                                .cornerRadius(12)
                                        }
                                        .padding(14)
                                        .background(Color.white.opacity(0.03))
                                        .cornerRadius(14)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(Color.white.opacity(0.06), lineWidth: 1)
                                        )
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 120)
                            }
                        }
                    }
                }
            }
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
