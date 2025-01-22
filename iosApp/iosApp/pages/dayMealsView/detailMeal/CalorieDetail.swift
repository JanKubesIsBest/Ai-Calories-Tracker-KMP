//
//  calorieDetail.swift
//  iosApp
//
//  Created by Jan Kubeš on 29.11.2024.
//  Copyright © 2024 orgName. All rights reserved.
//

import SwiftUI
import Shared

struct MealCaloriesDetail: View {
    @Environment(\.dismiss) var dismiss

    let meal: MealCaloriesDesc
    private let db: Database
    
    // @State properties declared but not initialized here.
    @State private var viewModel: CaloriesDetailViewModel
    
    @State private var totalCalories: Int32 = 0
    @State private var newHeading: String = ""
    
    init(meal: MealCaloriesDesc) {
        self.meal = meal
        
        // Setting the values for the edit section
        self.newHeading = self.meal.heading
        self.totalCalories = self.meal.totalCalories
        
        let driverFactory = DriverFactory()
        self.db = Database(databaseDriverFactory: driverFactory)
        
        // Create local temp values
        let initialViewModel = CaloriesDetailViewModel(database: db, meal: meal)
        
        
        // Assign them to the @State wrappers
        self._viewModel = State(initialValue: initialViewModel)
    }
    
    var body: some View {
        Observing(viewModel.caloriesDetailState) { state in
            List {
                Section {
                    Text("Heading:")
                        .bold()
                    + Text(" \(state.meal.heading)")
                    
                    Text("Description:")
                        .bold()
                    + Text(" \(state.meal.description_)")

                    Text("Date: ")
                        .bold()
                    + Text(viewModel.dateToStringFormat())

                    Text("Time: ")
                        .bold()
                    + Text(viewModel.timeToStringFormat())
                }
                
                Section(header: Text("Edit meal")) {
                    TextField("Heading", text: $newHeading)
                        .onSubmit {
                            viewModel.processUserIntents(userIntent: CaloriesDetailIntent.EditHeading(newHeading: newHeading))
                        }
                    TextField("Total Calories", value: $totalCalories, formatter: NumberFormatter())
                        .onSubmit {
                            viewModel.processUserIntents(userIntent: CaloriesDetailIntent.EditCalories(newCalories: totalCalories))
                        }

                    Button(role: .destructive) {
                        viewModel.processUserIntents(userIntent: CaloriesDetailIntent.Delete())
                        dismiss()
                    } label: {
                        Text("Delete")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(state.meal.heading)
        }
    }
}
