//
//  ShoolViewModel.swift
//  NYC Schools List
//
//  Created by Brandon Delgado on 1/10/25.
//

import Foundation
import SwiftUI
import Combine

class SchoolsViewModel: ObservableObject {
    @Published private(set) var schools: [SchoolWithSAT] = []
    @Published private(set) var isLoading = false
    @Published var error: Error?
    private var allSchools: [SchoolWithSAT] = []
    
    private var satScores: [String: SATScore] = [:] // DBN as key
    private var currentPage = 0
    private let pageSize = 20
    private var canLoadMorePages = true
    private var cancellables = Set<AnyCancellable>()
    private let schoolsService: SchoolsService
    
    init(schoolsService: SchoolsService = SchoolsService()) {
        self.schoolsService = schoolsService
        loadInitialData()
    }
    
    private func loadInitialData() {
        isLoading = true
        
        Publishers.Zip(
            schoolsService.fetchSchools(),
            schoolsService.fetchSATScores()
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            self?.isLoading = false
            if case .failure(let error) = completion {
                self?.error = error
            }
        } receiveValue: { [weak self] schools, satScores in
            self?.satScores = Dictionary(uniqueKeysWithValues:
                satScores.map { ($0.dbn, $0) }
            )
            
            let schoolsWithSAT = schools.map { school in
                SchoolWithSAT(
                    school: school,
                    satScore: self?.satScores[school.dbn]
                )
            }
            self?.allSchools = schoolsWithSAT
            self?.schools = Array(schoolsWithSAT.prefix(self?.pageSize ?? 20))
            self?.currentPage = 1
            self?.canLoadMorePages = schoolsWithSAT.count > self?.pageSize ?? 20
        }
        .store(in: &cancellables)
    }
    
    func loadMoreContentIfNeeded(currentItem: SchoolWithSAT?) {
        guard let currentItem = currentItem else {
            loadMoreContent()
            return
        }
        
        let thresholdIndex = schools.index(schools.endIndex, offsetBy: -5)
        if schools.firstIndex(where: { $0.id == currentItem.id }) == thresholdIndex {
            loadMoreContent()
        }
    }
    
    private func loadMoreContent() {
        guard !isLoading && canLoadMorePages else { return }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            let start = self.currentPage * self.pageSize
            let end = start + self.pageSize
            
            // Load from allSchools instead of existing schools
            let newSchools = Array(self.allSchools[start..<min(end, self.allSchools.count)])
            
            self.schools.append(contentsOf: newSchools)
            self.currentPage += 1
            self.isLoading = false
            self.canLoadMorePages = end < self.allSchools.count
        }
    }
}

