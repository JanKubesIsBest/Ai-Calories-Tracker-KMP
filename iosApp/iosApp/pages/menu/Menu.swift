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
    var body: some View {
        NavigationView {
            List {
                // Top card - slightly larger
                NavigationLink(destination: DayMealsView()) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Today")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("This day was not very productive yet...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading) // Increased height
                }

                // Smaller cards for the rest of the list
                ForEach(1..<5) { index in
                    NavigationLink(destination: DayMealsView()) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Day \(index)")
                                .font(.headline)
                            Text("This day you ate a lot of vegetables...")
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
