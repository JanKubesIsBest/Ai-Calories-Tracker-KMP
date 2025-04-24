import SwiftUI
import Shared

// Function to get current date in UTC
func getCurrentDateUTC() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone(identifier: "UTC")
    return formatter.string(from: Date())
}

// Root view to handle initial navigation
struct RootView: View {
    @State private var navigateToTodayMeals = false
    private let currentDate: String
    
    init() {
        self.currentDate = getCurrentDateUTC()
    }
    
    var body: some View {
        NavigationView {
            MenuView()
                .background(
                    NavigationLink(
                        destination: DayMealsView(date: currentDate),
                        isActive: $navigateToTodayMeals
                    ) {
                        EmptyView()
                    }
                    .hidden()
                )
        }
        .onAppear {
            navigateToTodayMeals = true
        }
    }
}

@main
struct iOSApp: App {
    init() {
        HelperKt.doInitKoin()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
