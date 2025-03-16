//
//  Menu.swift
//  iosApp
//
//  Created by Jan Kubeš on 16.01.2025.
//  Copyright © 2025 orgName. All rights reserved.
//
import SwiftUI
import Shared

struct MenuView: View {
    
    @State private var viewModel: MenuViewModel
    private let db: Database
    
    init() {
        let driverFactory = DriverFactory()
        self.db = Database(databaseDriverFactory: driverFactory)
        
        self._viewModel = State(initialValue: MenuViewModel(database: db))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .clipShape(LeftRoundedRectangle(radius: 20))
                .edgesIgnoringSafeArea(.all)
                
                if #available(iOS 17.0, *) {
                    List {
                        Observing(viewModel.menuState) { state in
                            TodayDay(day: state.days[0])
                            
                            ForEach(1..<state.days.count, id: \.self) { index in
                                NormalDay(day: state.days[index])
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                } else {
                    // Fallback
                }
            }
            .navigationTitle("Menu")
        }
    }
}

struct LeftRoundedRectangle: Shape {
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: radius, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: radius, y: height))
        path.addArc(
            center: CGPoint(x: radius, y: height - radius),
            radius: radius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: 0, y: radius))
        path.addArc(
            center: CGPoint(x: radius, y: radius),
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        path.closeSubpath()
        
        return path
    }
}
