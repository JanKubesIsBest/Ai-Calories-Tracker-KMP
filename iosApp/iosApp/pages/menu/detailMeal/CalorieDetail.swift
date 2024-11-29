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
    var meal: MealCaloriesDesc


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
                
            }) {
                Text("Delete")
            }
        }
        .navigationTitle(meal.heading)
        
        
    }
}
