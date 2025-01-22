//
//  DayItem.swift
//  iosApp
//
//  Created by Jan Kubeš on 22.01.2025.
//  Copyright © 2025 orgName. All rights reserved.
//
import SwiftUI
import Shared

struct NormalDay: View {
    var day: Day
    
    init(day: Day) {
        self.day = day
    }
    
    var body: some View {
        NavigationLink(destination: DayMealsView(date: day.date)) {
            // If it's the first item (index == 0), make a bigger card
            // Smaller card for the rest
            VStack(alignment: .leading, spacing: 8) {
                Text(day.title)
                    .font(.headline)
                Text(day.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                + Text(" Total calories: \(day.totalCalories)")
                    .font(.subheadline)
                    .bold()
            }
        }

    }
}

struct TodayDay: View {
    var day: Day
    
    init(day: Day) {
        self.day = day
    }
    
    var body: some View {
        NavigationLink(destination: DayMealsView(date: day.date)) {
            VStack(alignment: .leading, spacing: 8) {
                Text(day.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(day.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                + Text(" Total calories: \(day.totalCalories)")
                    .font(.subheadline)
                    .bold()
            }
            .frame(
                maxWidth: .infinity,
                minHeight: 250,
                alignment: .topLeading
            )
        }
        .listRowBackground(Color.blue)
    }
}
