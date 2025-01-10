//
//  SchoolListView.swift
//  NYC Schools List
//
//  Created by Brandon Delgado on 1/10/25.
//

import SwiftUI
import Foundation

struct SchoolListView: View {
    @StateObject private var viewModel = SchoolsViewModel()
    @State private var selectedSchool: SchoolWithSAT?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            NavigationView {
                ZStack {
                    if viewModel.isLoading && viewModel.schools.isEmpty {
                        ProgressView("Loading schools...")
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.schools) { schoolWithSAT in
                                    NavigationLink(destination: SchoolDetailView(schoolWithSAT: schoolWithSAT)) {
                                        SchoolCardView(schoolWithSAT: schoolWithSAT)
                                           
                                            .onAppear {
                                                viewModel.loadMoreContentIfNeeded(currentItem: schoolWithSAT)
                                            }
                                    }
                                }
                                
                                if viewModel.isLoading {
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                }
                            }
                            .padding()
                        }
                    }
                }
                .navigationTitle("NYC Schools")
                .alert("Error", isPresented: .constant(viewModel.error != nil)) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(viewModel.error?.localizedDescription ?? "Unknown error")
                }
            }
        }
    }
    
    struct SchoolCardView: View {
        let schoolWithSAT: SchoolWithSAT
        
        private var formattedAttendance: String {
            if let attendance = schoolWithSAT.school.attendanceRate,
               let attendanceDouble = Double(attendance) {
                return String(format: "%.1f%%", attendanceDouble * 100)
            }
            return "N/A"
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
             
                VStack(alignment: .leading, spacing: 4) {
                    Text(schoolWithSAT.school.schoolName)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    if let borough = schoolWithSAT.school.borough {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.blue)
                            Text(borough)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
               
                Rectangle()
                    .fill(LinearGradient(
                        colors: [.blue.opacity(0.5), .clear],
                        startPoint: .leading,
                        endPoint: .trailing))
                    .frame(height: 1)
                
             
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    // Students
                    if let students = schoolWithSAT.school.totalStudents {
                        StatisticView(
                            icon: "person.2.fill",
                            title: "Students",
                            value: students,
                            color: .blue
                        )
                    }
                    
                    // Attendance
                    StatisticView(
                        icon: "calendar.badge.clock",
                        title: "Attendance",
                        value: formattedAttendance,
                        color: .green
                    )
                    
                    // SAT Scores if available
                    if let satScore = schoolWithSAT.satScore {
                        if let mathScore = satScore.satMathAvgScore {
                            StatisticView(
                                icon: "function",
                                title: "SAT Math",
                                value: mathScore,
                                color: .purple
                            )
                        }
                        
                        if let readingScore = satScore.satCriticalReadingAvgScore {
                            StatisticView(
                                icon: "text.book.closed",
                                title: "SAT Reading",
                                value: readingScore,
                                color: .orange
                            )
                        }
                    }
                }
                
                
                if let neighborhood = schoolWithSAT.school.neighborhood {
                    HStack {
                        Image(systemName: "building.2.fill")
                            .foregroundColor(.gray)
                        Text(neighborhood)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                if let grades = schoolWithSAT.school.grades2018 {
                    HStack {
                        Image(systemName: "list.bullet.clipboard")
                            .foregroundColor(.gray)
                        Text("Grades: \(grades)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
            )
        }
    }

   
    struct StatisticView: View {
        let icon: String
        let title: String
        let value: String
        let color: Color
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(color)
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
        }
    }
}


#Preview {
    SchoolListView()
}
