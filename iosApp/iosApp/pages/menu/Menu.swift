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
            List {
                // ForEach over all days in viewModel.menuState.days
                Observing(viewModel.menuState) { state in
                    TodayDay(day: state.days[0])
                    
                    ForEach(1..<state.days.count, id: \.self) { index in
                        
                        NormalDay(day: state.days[index])
                    }
                }
            }.navigationTitle("Menu")
        }
    }
}
