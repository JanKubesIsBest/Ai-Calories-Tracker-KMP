//
//  CalorieItem.swift
//  iosApp
//
//  Created by Jan Kubeš on 09.11.2024.
//  Copyright © 2024 orgName. All rights reserved.
//

import SwiftUI
import Shared

@available(iOS 16.0, *)
struct CalorieItem: View {
    var meal: MealCaloriesDesc
    
    var body: some View {
        if #available(iOS 16.0, *) {
            VStack(alignment: .leading) {
                Text(meal.heading)
                    .font(.headline)
                Text(meal.description_)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                + Text(" Total calories: \(meal.totalCalories)")
                    .font(.subheadline)
                    .bold()
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
