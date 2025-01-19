//
//  Menu.swift
//  iosApp
//
//  Created by Jan Kubeš on 16.01.2025.
//  Copyright © 2025 orgName. All rights reserved.
//
import SwiftUI
import Shared

struct MenuView: View {
    
    @State private var viewModel: MenuViewModel
    
    init() {
        self._viewModel = State(initialValue: MenuViewModel())
    }
    
    var body: some View {
        NavigationView {
            List {
                // ForEach over all days in viewModel.menuState.days
                Observing(viewModel.menuState) { state in
                    NavigationLink(destination: DayMealsView(date: state.days[0].date)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(state.days[0].title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text(state.days[0].description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(
                            maxWidth: .infinity,
                            minHeight: 250,
                            alignment: .topLeading
                        )
                    }
                    .listRowBackground(Color.blue)
                    
                    ForEach(1..<state.days.count, id: \.self) { index in
                        let day = state.days[index]
                        
                        NavigationLink(destination: DayMealsView(date: day.date)) {
                            // If it's the first item (index == 0), make a bigger card
                            // Smaller card for the rest
                            VStack(alignment: .leading, spacing: 8) {
                                Text(day.title)
                                    .font(.headline)
                                Text(day.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }.navigationTitle("Menu")
        }
    }
}
