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
            
            if isKeyboardVisible {
                VStack {
                    Observing(viewModel.mealsInDayState) { state in
                        MealList(sections: state.mealSections)
                    }
                }
                .navigationTitle("Total Calories: " + String(viewModel.mealsInDayState.value.totalCalories))
                .onTapGesture {
                    self.endTextEditing()
                    print("Tap gesture: " + isKeyboardVisible.description)
                    // If keyboard is visible
                    isKeyboardVisible = false
                    isTextFieldFocused = false
                }
            } else {
                VStack {
                    Observing(viewModel.mealsInDayState) { state in
                        MealList(sections: state.mealSections)
                    }
                }
                .navigationTitle("Total Calories: " + String(viewModel.mealsInDayState.value.totalCalories))
            }
            
            if isKeyboardVisible {
                VStack {
                    TextField("Enter text", text: $newMeal)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle()) // Apply a rounded border
                        .background(Color.clear) // Clear background for the text field
                        .cornerRadius(8) // Optional: rounded corners
                        .focused($isTextFieldFocused) // Bind focus state to the TextField
                        .submitLabel(.done)
                        .onAppear {
                            // Automatically focus the TextField when it appears
                            isTextFieldFocused = true
                        }
                        .onSubmit {
                            viewModel.processUserIntents(userIntent: MealsInDayIntent.AddMeal(desc: newMeal))
                            newMeal = ""
                            
                            isTextFieldFocused = false
                            isKeyboardVisible = false
                        }
                }
            } else {
                Button(action: {
                    isKeyboardVisible = true
                }) {
                    Text("New Meal")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 10)
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
                            if #available(iOS 16.0, *) {
                                NavigationLink(destination: MealCaloriesDetail(meal: meal)) {
                                    CalorieItem(meal: meal)
                                }
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                }
            }
        }
    }
}
