import Foundation
import Shared // Import your shared module

class MenuViewModelWrapper: ObservableObject {
    private let kotlinViewModel: MenuViewModel

    // Published property for SwiftUI binding
    @Published var menuViewModelState: MenuViewState

    private var cancellable: Any?

    init(kotlinViewModel: MenuViewModel) {
        self.kotlinViewModel = kotlinViewModel

        // Initialize with the current state from the Kotlin ViewModel
        self.menuViewModelState = kotlinViewModel.menuViewModelState.value as! MenuViewState

    }

    func processUserIntents(userIntent: MenuIntent) {
        kotlinViewModel.processUserIntents(userIntent: userIntent)
    }

    func getTotalCalories() -> Int32 {
        return kotlinViewModel.getTotalCalories()
    }
}
