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
    let saveOnBoardingData: (String, Int, String, String) -> Void
    let closeOnBoarding: () -> Void
    
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    
    var body: some View {
        VStack (spacing: 0) {
            Text("Welcome to Calories Tracker!")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.bottom, 10)
            Divider()
            
            ZStack {
                    // First Sheet (sheetPoint == 0)
                    Sheet1(advanceAction: {
                        impactFeedback.impactOccurred()
                        advanceAction()
                    })
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .offset(x: sheetPoint == 0 ? 0 : -UIScreen.main.bounds.width) // Slide out to left when not active
                        .animation(.easeInOut(duration: 0.5), value: sheetPoint)
                    
                    // Second Sheet (sheetPoint == 1)
                    Sheet2(sheetPoint: sheetPoint, advanceAction: {
                        impactFeedback.impactOccurred()
                        advanceAction()
                    })
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .offset(x: sheetPoint == 1 ? 0 : (sheetPoint < 1 ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width)) // Slide out to left when inactive
                        .animation(.easeInOut(duration: 0.5), value: sheetPoint)
                    
                    // Third Sheet (sheetPoint == 2)
                    Sheet3(saveAction: {gender, weight, build, selectedCountry in

                        let safeGender = gender ?? "Not specified"
                        let safeWeight = weight ?? 0
                        let safeBuild = build ?? "Not specified"
                        let safeCountry = selectedCountry ?? "Not specified"
                        
                        // Here will be the actual logic
                        saveOnBoardingData(safeGender, safeWeight, safeBuild, safeCountry)
                        impactFeedback.impactOccurred()
                        advanceAction()
                    })
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .offset(x: sheetPoint == 2 ? 0 : (sheetPoint < 2 ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width)) // Slide in from right when active
                            .animation(.easeInOut(duration: 0.5), value: sheetPoint)
                    
                    Sheet4(dismissAction: {
                        impactFeedback.impactOccurred()
                        closeOnBoarding()
                    })
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .offset(x: sheetPoint >= 3 ? 0 : UIScreen.main.bounds.width)
                        .animation(.easeInOut(duration: 0.5), value: sheetPoint)
                    }

            
        }
        .background(Color.blue.opacity(0.2))
        .interactiveDismissDisabled()
        .padding(.top, 0)
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
                .font(.largeTitle)
                .fontWeight(.bold)
                .fixedSize(horizontal: false, vertical: true) // Ensure text wraps
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
                .fontWeight(.bold)
                .fixedSize(horizontal: false, vertical: true) // Ensure text wraps
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(showConclusionText ? 1 : 0)
            
            Spacer() // Push content to the top
            
            // Animated button
            Button(action: advanceAction) {
                Text("Show Me")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .padding(.top, 0)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .opacity(showButton ? 1 : 0)
        }
        .padding()
        .padding(.top, 0)
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
            
            Image("RightImageOnBoarding")
                .resizable()
                .scaledToFit()
                .frame(height: 330)
                .offset(x: animateRightImage ? 100 : 260)
                .opacity(animateRightImage ? 1 : 0)
                .rotationEffect(.degrees(-15))
            
            VStack(alignment: .leading) {
                // Main text (not animated)
                Text("Get calories with one sentence!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                // Subtitle (not animated)
                Text("Add Meal → Describe the things you ate or drank → Save!")
                    .font(.body)
                    .fontWeight(.bold)
                
                Spacer()
                // Animated button
                VStack (spacing: 0) {
                    Image("DownImageOnBoarding")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
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
                .offset(y: animateBottomImage ? 0 : 100)
                .opacity(animateBottomImage ? 1 : 0)
            }
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
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 2)) {
                        animateRightImage = true
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
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
    // Form state variables (all optional by default)
    @State private var selectedGender: String? = nil
    @State private var selectedWeight: Int? = nil
    @State private var build: String? = nil // Changed to String? for Picker
    @State private var selectedCountry: String? = nil
    
    // Action to save the data
    let saveAction: (String?, Int?, String?, String?) -> Void // Updated to String? for build
    
    // Gender, Build, and Country options (for pickers)
    private let genders = ["Male", "Female", "Other"]
    private let builds = ["Muscular", "Skinny", "Average", "Athletic", "Slim", "Heavy"]
    private let countries = ["USA", "UK", "Germany", "France", "Japan", "India", "Czechia", "Poland", "Other"]
    
    // Weight options (for simplicity, using a range)
    private let weights = Array(30...150) // 30 kg to 150 kg
    
    // Haptic feedback generator
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ScrollView {
            VStack {
                Image("Sheet2Pres")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width)
                    .clipped()
                    .ignoresSafeArea(edges: .horizontal)
                
                Text("Info")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Text("A bit of info, please! To make GPT-Calories the easiest and most precise tracking app, we need a little info from you.")
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 0)
                
                // Form Section
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Gender")
                        Spacer()
                        // Gender Picker
                        Picker(selection: $selectedGender, label: Text("Gender")) {
                            Text("Optional").tag(String?.none)
                            ForEach(genders, id: \.self) { gender in
                                Text(gender).tag(String?.some(gender))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(selectedGender == nil ? .gray : .black)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    HStack {
                        Text("Weight")
                        Spacer()
                        // Weight Picker
                        Picker(selection: $selectedWeight, label: Text("Weight")) {
                            Text("Optional").tag(Int?.none)
                            ForEach(weights, id: \.self) { weight in
                                Text("\(weight) Kg").tag(Int?.some(weight))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(selectedWeight == nil ? .gray : .black)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    // Build Picker
                    HStack {
                        Text("Build")
                        Spacer()
                        Picker(selection: $build, label: Text("Build")) {
                            Text("Optional").tag(String?.none)
                            ForEach(builds, id: \.self) { build in
                                Text(build).tag(String?.some(build))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(build == nil ? .gray : .black)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    HStack {
                        Text("Country of residence")
                        Spacer()
                        // Country Picker
                        Picker(selection: $selectedCountry, label: Text("Country")) {
                            Text("Optional").tag(String?.none)
                            ForEach(countries, id: \.self) { country in
                                Text(country).tag(String?.some(country))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(selectedCountry == nil ? .gray : .black)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack {
                    Text("Your Privacy Matters - You don't have to fill anything, but it may affect tracking accuracy.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    // Save Button
                    Button(action: {
                        impactFeedback.impactOccurred()
                        saveAction(selectedGender, selectedWeight, build, selectedCountry)
                    }) {
                        Text("Save!")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }.padding(.top, 20 )
            }
        }
    }
}


struct Sheet4: View {
    let dismissAction: () -> Void
    
    // Haptic feedback generator
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("You walked through onboarding!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("Now it is the time to start tracking, let's go 🚀")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 8)
            
            Spacer()
            
            Button(action: {
                impactFeedback.impactOccurred() // Trigger haptic feedback
                dismissAction()
            }) {
                Text("Track!")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
    }
}
