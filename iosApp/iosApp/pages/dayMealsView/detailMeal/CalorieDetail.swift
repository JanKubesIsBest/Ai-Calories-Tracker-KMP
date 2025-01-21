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
    @State private var totalCalories: Int32
    
    init(meal: MealCaloriesDesc) {
        self.meal = meal
        
        let driverFactory = DriverFactory()
        self.db = Database(databaseDriverFactory: driverFactory)
        
        // Create local temp values
        let initialViewModel = CaloriesDetailViewModel(database: db, meal: meal)
        let initialTotalCalories = meal.totalCalories
        
        // Assign them to the @State wrappers
        self._viewModel = State(initialValue: initialViewModel)
        self._totalCalories = State(initialValue: initialTotalCalories)
    }
    
    var body: some View {
        List {
            Section {
                Text("Description:")
                    .bold()
                + Text(" \(meal.description_)")

                Text("Date: ")
                    .bold()
//                + Text(viewModel.dateToStringFormat())

                Text("Time: ")
                    .bold()
//                + Text(viewModel.timeToStringFormat())
            }
            
            Section(header: Text("Edit meal")) {
                TextField("Total Calories", value: $totalCalories, formatter: NumberFormatter())

                Button(role: .destructive) {
                    dismiss()
                    viewModel.processUserIntents(userIntent: CaloriesDetailIntent.Delete())
                } label: {
                    Text("Delete")
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle(meal.heading)
    }
}
