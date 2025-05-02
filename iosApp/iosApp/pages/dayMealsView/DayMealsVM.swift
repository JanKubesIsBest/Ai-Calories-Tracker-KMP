//
//  DayMealsVM.swift
//  iosApp
//
//  Created by Jan Kubeš on 02.05.2025.
//  Copyright © 2025 orgName. All rights reserved.
//
import SwiftUI
import Shared

class DayMealsVM: ObservableObject {
    var model: MealsInDayViewModel
    
    // Create the driver and database
    private let driverFactory = DriverFactory()
    private let db: Database
    
    @Published var showAlertError = false
    @Published var showSheet = false
    
    
    init(date: String) {
        self.db = Database(databaseDriverFactory: driverFactory)
        model = MealsInDayViewModel(database: db, date: date)
    }
    
    @Published
    private(set) var state: MealsInDayState = MealsInDayState(meals: [], mealSections: [], mealDescription: "", totalCalories: 0, mealAddedError: false, showSheet: false)
    
    @MainActor
    func activate() async {
        for await state in model.mealsInDayState {
            self.state = state
            
            print(self.state.mealAddedError)
            self.showAlertError = self.state.mealAddedError
            self.showSheet = self.state.showSheet
            
        }
    }
}
