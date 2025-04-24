import SwiftUI
import Shared

struct DayMealsView: View {
    @State private var newMeal: String = ""
    @State private var isKeyboardVisible = false
    @FocusState private var isTextFieldFocused: Bool
    
    // Create the driver and database
    private let driverFactory = DriverFactory()
    private let db: Database
    
    // Initialize the view model
    @State private var viewModel: MealsInDayViewModel
    
    init(date: String) {
        self.db = Database(databaseDriverFactory: driverFactory)
        self._viewModel = State(initialValue: MealsInDayViewModel(database: db, date: date))
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            Observing(viewModel.mealsInDayState) { state in
                if isKeyboardVisible {
                    VStack {
                        MealList(sections: state.mealSections)
                    }
                    .navigationTitle("Total Calories: " + String(state.totalCalories))
                    .onTapGesture {
                        self.endTextEditing()
                        print("Tap gesture: " + isKeyboardVisible.description)
                        // If keyboard is visible
                        isKeyboardVisible = false
                        isTextFieldFocused = false
                    }
                } else {
                    VStack {
                        MealList(sections: state.mealSections)
                    }
                    .navigationTitle("Total Calories: " + String(state.totalCalories))
                }
                
                if isKeyboardVisible {
                    VStack {
                        MealInputView(text: $newMeal, onSubmit: {_ in
                            isKeyboardVisible = false
                            if (newMeal.isEmpty) {
                                return
                            } else {
                                viewModel.processUserIntents(userIntent: MealsInDayIntent.AddMeal(desc: newMeal))
                                newMeal = ""
                            }
                        })
                    }
                } else {
                    Button(action: {
                        isKeyboardVisible = true
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
                            if (meal.description_ != "Loading..."){
                                NavigationLink(destination: MealCaloriesDetail(meal: meal)) {
                                    CalorieItem(meal: meal)
                                }
                            } else {
                                CalorieItem(meal: meal)
                            }
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
