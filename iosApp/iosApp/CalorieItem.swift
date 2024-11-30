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
    @State private var path = NavigationPath() // Use `NavigationPath` for more robust navigation in iOS 16+

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack(path: $path) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(meal.heading)
                            .font(.headline)
                        Text(meal.description_ + " Total calories: \(meal.totalCalories)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer() // Pushes the arrow to the far right
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    print("Navigating to Meal Details")
                    path.append(meal) // Pass the meal object to the destination
                }
                .navigationDestination(for: MealCaloriesDesc.self) { meal in
                    MealCaloriesDetail(meal: meal)
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
