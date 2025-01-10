//
//  Models.swift
//  NYC Schools List
//
//  Created by Brandon Delgado on 1/10/25.
//

import Foundation
import Combine




class SchoolsService {
    private let schoolsURL = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
    private let satScoresURL = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json"
    
    func fetchSchools() -> AnyPublisher<[School], Error> {
        guard let url = URL(string: schoolsURL) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [School].self, decoder: JSONDecoder())
            .mapError { error -> Error in
                if error is DecodingError {
                    return NetworkError.decodingError
                }
                return NetworkError.serverError(error)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchSATScores() -> AnyPublisher<[SATScore], Error> {
        guard let url = URL(string: satScoresURL) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [SATScore].self, decoder: JSONDecoder())
            .mapError { error -> Error in
                if error is DecodingError {
                    return NetworkError.decodingError
                }
                return NetworkError.serverError(error)
            }
            .eraseToAnyPublisher()
    }
}

struct School: Identifiable, Codable {
    let dbn: String
    let schoolName: String
    let neighborhood: String?
    let grades2018: String?
    let totalStudents: String?
    let attendanceRate: String?
    let borough: String?
    let overviewParagraph: String?
    let academicOpportunities1: String?
    let academicOpportunities2: String?
    let schoolSports: String?
    let extracurricularActivities: String?
    let primaryAddressLine1: String?
    let city: String?
    let zip: String?
    let subway: String?
    let bus: String?
    let admissionsPriority11: String?
    let requirement11: String?
    let website: String?
    let phoneNumber: String?
    let schoolEmail: String?
    
    var id: String { dbn }
    
    enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case neighborhood
        case grades2018
        case totalStudents = "total_students"
        case attendanceRate = "attendance_rate"
        case borough = "boro"
        case overviewParagraph = "overview_paragraph"
        case academicOpportunities1 = "academicopportunities1"
        case academicOpportunities2 = "academicopportunities2"
        case schoolSports = "school_sports"
        case extracurricularActivities = "extracurricular_activities"
        case primaryAddressLine1 = "primary_address_line_1"
        case city
        case zip
        case subway
        case bus
        case admissionsPriority11 = "admissionspriority11"
        case requirement11 = "requirement1_1"
        case website
        case phoneNumber = "phone_number"
        case schoolEmail = "school_email"
    }
}

struct SATScore: Codable {
    let dbn: String
    let schoolName: String
    let numOfSatTestTakers: String?
    let satCriticalReadingAvgScore: String?
    let satMathAvgScore: String?
    let satWritingAvgScore: String?
    
    enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case numOfSatTestTakers = "num_of_sat_test_takers"
        case satCriticalReadingAvgScore = "sat_critical_reading_avg_score"
        case satMathAvgScore = "sat_math_avg_score"
        case satWritingAvgScore = "sat_writing_avg_score"
    }
}

struct SchoolWithSAT: Identifiable {
    let school: School
    var satScore: SATScore?
    
    var id: String { school.dbn }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(Error)
}
