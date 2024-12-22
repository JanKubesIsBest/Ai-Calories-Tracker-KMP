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
    
    var meal: MealCaloriesDesc
    
    private let driverFactory = DriverFactory()
    private let db: Database
    
    // Initialize the view model
    @State private var viewModel: CaloriesDetailViewModel

    init(meal: MealCaloriesDesc) {
        self.meal = meal
        self.db = Database(databaseDriverFactory: driverFactory)
        self._viewModel = State(initialValue: CaloriesDetailViewModel(database: db, meal: self.meal))
    }
    
    var body: some View {
        List {
            Text("Description: ")
                .bold()
                .font(.body)
                .foregroundColor(.primary) +
            Text(meal.description_)
                .font(.body)
                .foregroundColor(.primary)
            
            Button(action: {
                dismiss()
                print("Dismissing")
                viewModel.processUserIntents(userIntent: CaloriesDetailIntent.Delete())
            }) {
                Text("Delete")
            }
        }
        .navigationTitle(meal.heading)
        
        
    }
}
