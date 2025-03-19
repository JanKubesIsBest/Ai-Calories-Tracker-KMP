//
//  DayItem.swift
//  iosApp
//
//  Created by Jan Kubeš on 22.01.2025.
//  Copyright © 2025 orgName. All rights reserved.
//
import SwiftUI
import Shared
import Charts

struct NormalDay: View {
    var day: Day
    
    init(day: Day) {
        self.day = day
    }
    
    var body: some View {
        NavigationLink(destination: DayMealsView(date: day.date)) {
            if #available(iOS 16.1, *) {
                HStack {
                    VStack (alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text(day.title)
                                .font(.headline)
                                .foregroundColor(Color.black)
                            Text(day.description_)
                                .font(.subheadline)
                                .foregroundColor(Color.black)
                            + Text(" Total calories: \(day.totalCalories)")
                                .font(.subheadline)
                                .foregroundColor(Color.black)
                                .bold()
                            
                        }
                        .multilineTextAlignment(.leading)
                        
                        
                        Divider()
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.black)
                }
            } else {
                // Fallback on earlier versions
            }
        }
        .padding(.vertical, 8)
        .frame(width: 350)
    }
}

struct TodayDay: View {
    var day: Day
    
    init(day: Day) {
        self.day = day
    }
    
    var body: some View {
        NavigationLink(destination: DayMealsView(date: day.date)) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(day.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 5)
                    Text(day.description_)
                        .font(.subheadline)
                        .foregroundColor(Color.black)
                    + Text(" Total calories: \(day.totalCalories)")
                        .font(.subheadline)
                        .bold()
                    
                    if #available(iOS 16.0, *) {
                        Chart {
                            ForEach(MealsInDayViewModel.companion.groupMealsByTimeDifference(meals: day.meals), id: \.self) { section in
                                BarMark(
                                    x: .value("Time", section.sectionName),
                                    y: .value("Total Calories", section.totalCalories())
                                )
                            }
                        }
                        .padding(.top, 10)
                    }
                    
                    Divider()
                }
                .multilineTextAlignment(.leading)
                .frame(
                    minHeight: 250,
                    alignment: .topLeading
                )
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
        }
        .padding(.vertical, 8)
        .frame(width: 350)
        .padding(.horizontal, 15)
    }
}
