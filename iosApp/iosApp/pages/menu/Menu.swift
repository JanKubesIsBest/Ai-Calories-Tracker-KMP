//
//  Menu.swift
//  iosApp
//
//  Created by Jan Kubeš on 16.01.2025.
//  Copyright © 2025 orgName. All rights reserved.
//
import SwiftUI
import Shared

// TODO: Create a view model on the Kotlin side which will retrieve the list of the days and assign needed data
// You need to change a little getAllMeals funciton in Sql in order for it to retrieve only data needed for that day --> then the only change needed for the whole structure is just passing a data the the DayMealsView()...
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
                    ForEach(0..<state.days.count, id: \.self) { index in
                        let day = state.days[index]
                        
                        NavigationLink(destination: DayMealsView(date: day.date)) {
                            // If it's the first item (index == 0), make a bigger card
                            if index == 0 {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(day.title)
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                    Text(day.description)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .frame(
                                    maxWidth: .infinity,
                                    minHeight: 120,
                                    alignment: .leading
                                )
                            } else {
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
                    .listStyle(InsetGroupedListStyle())
                    .navigationTitle("Menu")
                }
            }
        }
    }
}
