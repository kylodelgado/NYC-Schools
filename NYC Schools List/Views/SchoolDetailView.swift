//
//  SchoolDetailView.swift
//  NYC Schools List
//
//  Created by Brandon Delgado on 1/10/25.
//

import SwiftUI
import Foundation

struct SchoolDetailView: View {
    let schoolWithSAT: SchoolWithSAT
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AcademicBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header Card
                        VStack(alignment: .leading, spacing: 12) {
                            // School Info
                            VStack(alignment: .leading, spacing: 8) {
                                if let borough = schoolWithSAT.school.borough {
                                    Text(borough.uppercased())
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                HStack {
                                    if let students = schoolWithSAT.school.totalStudents {
                                        StatisticView(
                                            icon: "person.2.fill",
                                            value: students,
                                            label: "Students"
                                        )
                                    }
                                    
                                    if let attendance = schoolWithSAT.school.attendanceRate,
                                       let attendanceDouble = Double(attendance) {
                                        StatisticView(
                                            icon: "chart.bar.fill",
                                            value: "\(Int(attendanceDouble * 100))%",
                                            label: "Attendance"
                                        )
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        
                        // SAT Scores Card
                        if let satScore = schoolWithSAT.satScore {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("SAT Performance")
                                    .font(.title2)
                                    .bold()
                                
                                HStack {
                                    SATScoreView(
                                        score: satScore.satMathAvgScore ?? "N/A",
                                        subject: "Mathematics",
                                        icon: "function"
                                    )
                                    
                                    Divider()
                                    
                                    SATScoreView(
                                        score: satScore.satCriticalReadingAvgScore ?? "N/A",
                                        subject: "Reading",
                                        icon: "book.fill"
                                    )
                                    
                                    Divider()
                                    
                                    SATScoreView(
                                        score: satScore.satWritingAvgScore ?? "N/A",
                                        subject: "Writing",
                                        icon: "pencil"
                                    )
                                }
                                
                                if let testTakers = satScore.numOfSatTestTakers {
                                    Text("Based on \(testTakers) test takers")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(radius: 2)
                        }
                        
                        // Overview Card
                        if let overview = schoolWithSAT.school.overviewParagraph {
                            InfoCard(title: "School Overview") {
                                Text(overview)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        
                        // Opportunities
                        if let opportunities1 = schoolWithSAT.school.academicOpportunities1,
                           let opportunities2 = schoolWithSAT.school.academicOpportunities2 {
                            InfoCard(title: "Academic Programs") {
                                VStack(alignment: .leading, spacing: 8) {
                                    BulletPoint(text: opportunities1)
                                    BulletPoint(text: opportunities2)
                                }
                            }
                        }
                        
                        // Activities
                        if let activities = schoolWithSAT.school.extracurricularActivities {
                            InfoCard(title: "Student Life") {
                                Text(activities)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        
                        // Contact Information
                        InfoCard(title: "Contact Information") {
                            VStack(alignment: .leading, spacing: 12) {
                                if let address = schoolWithSAT.school.primaryAddressLine1 {
                                    ContactRow(icon: "mappin.circle.fill", text: address)
                                }
                                
                                if let phone = schoolWithSAT.school.phoneNumber {
                                    ContactRow(icon: "phone.fill", text: phone)
                                }
                                
                                if let email = schoolWithSAT.school.schoolEmail {
                                    ContactRow(icon: "envelope.fill", text: email)
                                }
                                
                                if let website = schoolWithSAT.school.website {
                                    ContactRow(icon: "globe", text: website)
                                }
                            }
                        }
                        
                        // Transportation
                        InfoCard(title: "Transportation") {
                            VStack(alignment: .leading, spacing: 12) {
                                if let subway = schoolWithSAT.school.subway {
                                    TransportRow(icon: "tram.fill", text: subway)
                                }
                                
                                if let bus = schoolWithSAT.school.bus {
                                    TransportRow(icon: "bus", text: bus)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(schoolWithSAT.school.schoolName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }.navigationBarBackButtonHidden()
    }
}

