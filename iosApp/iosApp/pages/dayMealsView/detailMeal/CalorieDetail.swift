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

    private let db: Database
    
    // @State properties declared but not initialized here.
    @State private var viewModel: CaloriesDetailViewModel
    
    
    @State private var totalCalories: Int32 = 0
    @State private var newHeading: String = ""
    @State private var time = Date()
    
    init(meal: MealCaloriesDesc) {
        // Setting the values for the edit section
        self.newHeading = meal.heading
        self.totalCalories = meal.totalCalories
        if (ISO8601DateFormatter().date(from: meal.date) != nil) {
            self.time = ISO8601DateFormatter().date(from: meal.date)!
        }
        
        
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
                    Text("Heading: ")
                        .bold()
                    + Text(state.meal.heading)
                    
                    Text("Description: ")
                        .bold()
                    + Text(state.meal.description_)

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
                    
                    DatePicker(selection: $time, displayedComponents: .hourAndMinute, label: { Text("Time:") })
                        .onChange(of: time) { newTime in
                            let (hours, minutes) = getHoursAndMinutes(from: time)
                            
                            viewModel.processUserIntents(userIntent: CaloriesDetailIntent.EditTime(hour: Int32(hours), minute: Int32(minutes)));
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
    
    func getHoursAndMinutes(from date: Date) -> (hours: Int, minutes: Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        return (components.hour ?? 0, components.minute ?? 0)
    }
}
