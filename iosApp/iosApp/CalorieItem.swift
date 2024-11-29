//
//  CalorieItem.swift
//  iosApp
//
//  Created by Jan Kubeš on 09.11.2024.
//  Copyright © 2024 orgName. All rights reserved.
//

import SwiftUI
import Shared

struct CalorieItem: View {
    var meal: MealCaloriesDesc
    @State var goToDetails = false
    
    @State var path = [String]()


    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack (path: $path) {
                Button (action: {
                    print("Clicked")
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(meal.heading)
                                .font(.headline)
                            Text(meal.description_ + " Total calories: \(meal.totalCalories)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }.onTapGesture {
                            print("Clicked")
                            path.append("MealDetails")
                        }
                        Spacer()  // Pushes the arrow to the far right
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .navigationDestination(for: String.self) { string in
                        MealCaloriesDetail(meal: meal)
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
                
    }
}
