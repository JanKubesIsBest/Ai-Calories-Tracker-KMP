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
    @State private var shimmerOffset: CGFloat = -1.0 // Start off-screen to the left
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(meal.heading)
                .font(.headline)
            
            if meal.description_ == "Loading..." {
                // Shimmer effect for loading state
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 20)
                        .cornerRadius(4)
                    
                    GeometryReader { geometry in
                        LinearGradient(
                            gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.5), Color.clear]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: geometry.size.width * 0.3)
                        .offset(x: geometry.size.width * shimmerOffset)
                        .animation(
                            Animation.linear(duration: 1.5)
                                .repeatForever(autoreverses: false),
                            value: shimmerOffset
                        )
                    }
                }
                .onAppear {
                    shimmerOffset = 1.0 // Move to the right side
                }
            } else {
                // Actual content when not loading
                Text(meal.description_)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                + Text(" Total calories: \(meal.totalCalories)")
                    .font(.subheadline)
                    .bold()
            }
        }
    }
}
