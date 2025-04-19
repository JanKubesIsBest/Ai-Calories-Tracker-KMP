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
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        let driverFactory = DriverFactory()
        self.db = Database(databaseDriverFactory: driverFactory)
        self._viewModel = State(initialValue: MenuViewModel(database: db))
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(Color(hex: "F2F2F7").opacity(0.9))
        
        appearance.shadowColor = .gray // Color of the divider
        
        UINavigationBar.appearance().standardAppearance = appearance
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
                    }.background(Color(hex: "F2F2F7"))
                    
                    
                } else {
                    // Fallback on earlier versions
                }
            }
            .onAppear {
                viewModel.processUserIntents(userIntent: MenuIntent.GetDays())
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    // App became active (e.g., reopened from background)
                    viewModel.processUserIntents(userIntent: MenuIntent.GetDays())
                }
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
