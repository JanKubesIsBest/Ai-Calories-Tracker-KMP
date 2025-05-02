//
//  OnBoarding.swift
//  iosApp
//
//  Created by Jan Kubeš on 02.05.2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI
import Shared

struct OnboardingSheetView: View {
    let sheetPoint: Int
    let advanceAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Welcome to GPT-Calories!")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            Divider()
            
            ZStack {
                    // First Sheet (sheetPoint == 0)
                    Sheet1(advanceAction: advanceAction)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(x: sheetPoint == 0 ? 0 : -UIScreen.main.bounds.width) // Slide out to left when not active
                        .animation(.easeInOut(duration: 0.5), value: sheetPoint)
                    
                    // Second Sheet (sheetPoint == 1)
                    Sheet2(sheetPoint: sheetPoint, advanceAction: advanceAction)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(x: sheetPoint == 1 ? 0 : (sheetPoint < 1 ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width)) // Slide out to left when inactive
                        .animation(.easeInOut(duration: 0.5), value: sheetPoint)
                    
                    // Third Sheet (sheetPoint == 2)
                    Sheet3()
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(x: sheetPoint >= 2 ? 0 : UIScreen.main.bounds.width) // Slide in from right when active
                        .animation(.easeInOut(duration: 0.5), value: sheetPoint)
                }
        }
        .background(Color.blue.opacity(0.2))
        .interactiveDismissDisabled()
    }
}

struct Sheet1: View {
    let advanceAction: () -> Void
    
    // State variables to control the visibility of each animated element
    @State private var showIntroText = false
    @State private var showBullet1 = false
    @State private var showBullet2 = false
    @State private var showBullet3 = false
    @State private var showBullet4 = false
    @State private var showConclusionText = false
    @State private var showButton = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Static text (not animated)
            Text("The easiest way to track calories...")
                .font(.title)
                .fontWeight(.bold)
            
            // Animated intro text
            Text("You have tried:")
                .font(.body)
                .opacity(showIntroText ? 1 : 0)
            
            // Animated bullet points
            VStack(alignment: .leading, spacing: 10) {
                Text("• Memorizing things you ate...")
                    .opacity(showBullet1 ? 1 : 0)
                Text("• Writing the meals you ate...")
                    .opacity(showBullet2 ? 1 : 0)
                Text("• Weighing every gram of your meal...")
                    .opacity(showBullet3 ? 1 : 0)
                Text("• Scanning barcodes...")
                    .opacity(showBullet4 ? 1 : 0)
            }
            
            // Animated conclusion text
            Text("To be honest, all of them are really time consuming, so let's explore another way 👉")
                .font(.title)
                .opacity(showConclusionText ? 1 : 0)
            
            Spacer() // Push content to the top
            
            // Animated button
            Button(action: advanceAction) {
                Text("Show Me")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .opacity(showButton ? 1 : 0)
        }
        .padding()
        .padding(.top, 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeIn(duration: 0.5)) {
                    showIntroText = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeIn(duration: 0.5)) {
                    showBullet1 = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeIn(duration: 0.5)) {
                    showBullet2 = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                withAnimation(.easeIn(duration: 0.5)) {
                    showBullet3 = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation(.easeIn(duration: 0.5)) {
                    showBullet4 = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                withAnimation(.easeIn(duration: 0.5)) {
                    showConclusionText = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                withAnimation(.easeIn(duration: 0.5)) {
                    showButton = true
                }
            }
        }
    }
}


struct Sheet2: View {
    let sheetPoint: Int
    let advanceAction: () -> Void
    
    // State variables to control animation
    @State private var animateLeftImage = false
    @State private var animateRightImage = false
    @State private var animateBottomImage = false
    
    var body: some View {
        ZStack {
            Image("LeftImageOnBoarding")
                .resizable()
                .scaledToFit()
                .frame(height: 340)
                .offset(x: animateLeftImage ? -130 : -260)
                .opacity(animateLeftImage ? 1 : 0)
                .rotationEffect(.degrees(15))
            
            VStack(alignment: .leading) {
                // Main text (not animated)
                Text("Get calories with one sentence!")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                // Subtitle (not animated)
                Text("Add Meal → Describe the things you ate or drank → Save!")
                    .font(.body)
                
                Spacer()
                // Animated button
                VStack (spacing: 0) {
                    Image("DownImageOnBoarding")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .offset(y: animateBottomImage ? 0 : 100)
                        .opacity(animateBottomImage ? 1 : 0)
                    Button(action: advanceAction) {
                        Text("WOW!")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .padding(.top, 0)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .opacity(1)
                }
            }
            
            Image("RightImageOnBoarding")
                .resizable()
                .scaledToFit()
                .frame(height: 330)
                .offset(x: animateRightImage ? 120 : 260)
                .opacity(animateRightImage ? 1 : 0)
                .rotationEffect(.degrees(-15))
        }
        .padding()
        .padding(.top, 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .onChange(of: sheetPoint) { newValue in
            if newValue == 1 {
                // Trigger animations when Sheet2View is active
                withAnimation(.easeInOut(duration: 2)) {
                    animateLeftImage = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 2)) {
                        animateRightImage = true
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        animateBottomImage = true
                    }
                }
            } else if (newValue > 1) {
                animateLeftImage = true
                animateRightImage = true
                animateBottomImage = true
            }
            else {
                // Reset animations when Sheet2View is not active
                animateLeftImage = false
                animateRightImage = false
                animateBottomImage = false
            }
        }
    }
}


struct Sheet3: View {
    var body: some View {
        VStack {
            Image ("Sheet2Pres")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
        }
    }
}
