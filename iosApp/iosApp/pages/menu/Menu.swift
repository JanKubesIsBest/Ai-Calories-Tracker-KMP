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
        GeometryReader { geometry in
            NavigationView {
                
                // Scrollable content
                if #available(iOS 17.0, *) {
                        // Background image as a separate layer
                        
                            ScrollView {
                                ZStack {
                                    Image("eclipse")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 800, height: 800)
                                        .offset(x: -120, y: -700)
                                        .edgesIgnoringSafeArea(.all)
                                    
                                    VStack {
                                        Observing(viewModel.menuState) { state in

                                                
                                            TodayDay(day: state.days[0])

                                            
                                            ForEach(1..<state.days.count, id: \.self) { index in
                                                    NormalDay(day: state.days[index])
                                                
                                            }
                                        }
                                    }
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .padding(10)
                                    .padding(.horizontal, geometry.safeAreaInsets.leading)
                                    .frame(minWidth: 400)
                                    .navigationTitle("Menu")
                                }
                            }
                    
                    
                } else {
                    // Fallback on earlier versions
                }
            }

        }
    }
}
