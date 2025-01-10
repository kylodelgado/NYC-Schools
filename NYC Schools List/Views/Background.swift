//
//  Background.swift
//  NYC Schools List
//
//  Created by Brandon Delgado on 1/10/25.
//

import SwiftUI

struct AcademicBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemBackground),
                    Color(.systemGray6)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .ignoresSafeArea()
    }
}
