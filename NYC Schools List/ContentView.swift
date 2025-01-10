//
//  ContentView.swift
//  NYC Schools List
//
//  Created by Brandon Delgado on 1/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            AcademicBackground()
            SchoolListView()
        }
    }
}

#Preview {
    ContentView()
}
