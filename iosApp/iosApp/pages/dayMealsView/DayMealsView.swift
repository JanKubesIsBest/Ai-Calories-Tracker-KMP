import SwiftUI
import Shared

struct DayMealsView: View {
    @State private var newMeal: String = ""
    @State private var isKeyboardVisible = false
    @FocusState private var isTextFieldFocused: Bool
    
    @StateObject private var viewModel: DayMealsVM
    
    init(date: String) {
        _viewModel = StateObject(wrappedValue: DayMealsVM(date: date))
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
                VStack {
                    if isKeyboardVisible {
                        VStack {
                            MealList(sections: viewModel.state.mealSections)
                        }
                        .navigationTitle("Total Calories: " + String(viewModel.state.totalCalories))
                        .navigationBarTitleDisplayMode(.large)
                        .onTapGesture {
                            self.endTextEditing()
                            print("Tap gesture: " + isKeyboardVisible.description)
                            // If keyboard is visible
                            isKeyboardVisible = false
                            isTextFieldFocused = false
                        }
                    } else {
                        VStack {
                            MealList(sections: viewModel.state.mealSections)
                        }
                        .navigationTitle("Total Calories: " + String(viewModel.state.totalCalories))
                        .navigationBarTitleDisplayMode(.large)
                    }
                    
                    if isKeyboardVisible {
                        VStack {
                            MealInputView(text: $newMeal, onSubmit: {_ in
                                withAnimation {
                                    self.endTextEditing()
                                    isKeyboardVisible = false
                                }
                                
                                if (newMeal.isEmpty) {
                                    return
                                } else {
                                    viewModel.model.processUserIntents(userIntent: MealsInDayIntent.AddMeal(desc: newMeal))
                                    newMeal = ""
                                }
                            })
                        }
                    } else {
                        Button(action: {
                            withAnimation {
                                isKeyboardVisible = true
                            }
                        }) {
                            Text("Add Meal")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding(.bottom, 20)
                        }
                        .padding(.horizontal, 10)
                    }
                }
                .task {
                    await viewModel.activate()
                }
                // Onboarding
                .sheet(isPresented: $viewModel.showSheet) {
                    OnboardingSheetView(
                        sheetPoint: Int(viewModel.state.sheetPoint),
                        advanceAction: {
                            viewModel.model.processUserIntents(userIntent: MealsInDayIntent.AdvanceOnBoarding())
                        },
                        saveOnBoardingData:  { gender, weight, build, selectedCountry in
                            
                            viewModel.model.processUserIntents(userIntent: MealsInDayIntent.SaveOnBoardingData(gender: gender, weight: Int32(weight), build: build, selectedCountry: selectedCountry));
                        },
                        closeOnBoarding: {
                            viewModel.model.processUserIntents(userIntent: MealsInDayIntent.CloseOnBoarding())
                        }
                    )
                }
                .alert("Error Occured", isPresented: $viewModel.showAlertError, ) {
                    Button(role: .cancel) {
                        viewModel.model.processUserIntents(userIntent: MealsInDayIntent.ErrorMessageDismissed())
                    } label: {
                        Text("Ok")
                    }
                } message: {
                    Text("An error occured, have you added a real meal?")
                }
            
        } else {
            // Fallback on earlier versions
            Text("Hello, World!")
        }
    }
}

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}


@available(iOS 16.0, *)
struct MealList: View {
    var sections: [MealSection]
    
    @State private var path = NavigationPath()
    
    init (sections: [MealSection]) {
        self.sections = sections
    }
    
    var body: some View {
        if (sections.count == 0) {
            Text("Zero meals recorded for this day")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        } else {
            List {
                
                ForEach(sections, id: \.self) { timeSection in
                    Section(
                        header: Text(timeSection.sectionName)
                            .headerProminence(.increased)
                    ) {
                        ForEach(timeSection.meals, id: \.id) { meal in
                            NavigationLink(destination: MealCaloriesDetail(meal: meal)) {
                                CalorieItem(meal: meal)
                            }
                            .disabled(meal.description_ == "Loading...")
                        }
                    }
                }
            }
        }
    }
}

struct MealInputView: View {
    @Binding var text: String
    var onSubmit: (String) -> Void
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            TextField("Describe the meal...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($isFocused)
                .onSubmit {
                    onSubmit(text)
                }
                .submitLabel(.go)
            
            
            Button(action: {
                onSubmit(text)
            }) {
                Image(systemName: "arrow.up")
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(text.isEmpty ? Color.gray : Color.blue)
                    .clipShape(Circle())
            }
            .disabled(text.isEmpty)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .accentColor(.blue)
        .onAppear {
            isFocused = true
        }
    }
}
