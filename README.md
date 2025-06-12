# App Overview - Purpose

There are two reasons I started developing this app:
* **Learn Kotlin Multiplatform**
    * I feel that Kotlin Multiplatform is the future - it combines a native UI, allowing for a smooth experience, with shared logic, allowing faster development.
    * I still see a place for Flutter, but while I worked at NFCtron, I saw the opportunity in KMP as well.
    * I wrote about this opportunity a little in my more finance-focused article on X [here]([url](https://x.com/_Kubes_Jan/status/1901003267183698324)).
* **Explore the possibilities of using LLMs to track your calorie intake.**
    * Although taking pictures of your food, as explored by many apps already, might seem easier at first, the text experience feels not only more private but also allows for more description for the model to assess the total calorie count.

** App is avaiable to download [here]([url](https://apps.apple.com/cz/app/calories-tracker-by-jan/id6744899705) **

## App Overview - Project Design

Although this is a project I am working on alongside school and other smaller projects, I think it is much better to have basic designs in Figma. This allowed me to assess whether I really wanted to work on it.

I also try to adhere to Apple's design language while bringing new, in my view, more user-friendly features. This is visible, for example, in the 'add new meal' view. The typical Apple approach, as seen in the Notes app menu, would be to add a small **+ button in the top-right corner**. This feels very unintuitive when you realize that this is the most used button on that screen. **That's why I decided to use a large *'Add new meal'* button, which expands into an input field.** This design feature is inspired by Arc Search, which uses something similar.

<img width="402" alt="Image" src="https://github.com/user-attachments/assets/56abade6-8cda-43c5-af16-183b7396272e" />
<br/>

*Snapshot from Figma*

## Current App Status

The app is currently developed only for iOS. Currently, the core logic is working: **Add a new meal → store it → display total calories → edit previous meals**.

Enjoy the simple user flow available, shown right here:
![Image](https://github.com/user-attachments/assets/e1de82c5-8d54-4a3d-8f33-d4a6ae24210d)

## Internal App Structure

If you would like to examine the app a little more, I have tried to stick to a simple committing system:
* **feat**: New feature
* **fix**: Bug fix

* Then parentheses containing either `Shared`, `iOS`, or `both`. This way, you can quickly look at the specific changes in the app's structure.
* Followed by the exact description of the fix or feature.

### Shared:
The structure is quite simple.

I am using SQLDelight. Every function needed for operation is in the `Database` class. This class is then accessed by the shared view models. The same goes for networking, which is done through use cases. The only use case right now is asking an LLM how many calories are in the meal. The LLM returns JSON, which is parsed into a `Meal` instance.

<img width="402" alt="Image" src="https://github.com/user-attachments/assets/26ae1859-3323-46c1-87c0-d73d6549fdfa" />

Let's look at a view model example.
<img width="1815" alt="Image" src="https://github.com/user-attachments/assets/c67d10d3-dc43-4d1f-ad01-73a6258f5db1" />

Almost every view model can access `AppViewModel`, which is crucial for managing state throughout the entire application and is injected using Koin. This view model is used to update state between different view models. This way, I can, for example, update the state on the day screen (the screen showing meals eaten that day) when I delete a meal in the meal detail view.

### UI
<img width="2272" alt="Image" src="https://github.com/user-attachments/assets/5934319c-ae34-4247-b758-71215fe1c54a" />

Every screen is written natively with SwiftUI. To work with state in Swift, I am using SKIE, which is by far the easiest integration for managing state in KMP applications.

The Swift code is quite simple because all the more complex functionality is written in Kotlin, and I just access it through the view models. Let's look at an example here:
```swift
if isKeyboardVisible {
    VStack {
        TextField("Enter text", text: $newMeal)
            .padding()
            .textFieldStyle(.roundedBorder) // Apply a rounded border style
            .background(.clear) // Clear background for the text field
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
}
```

As you can see, the only *"logic"* here is adding a new meal. This is achieved through the function `viewModel.processUserIntents(userIntent: MealsInDayIntent.AddMeal(desc: newMeal))`, which sends a signal to the view model: *"Hey, I'm adding a new meal."* Everything else is then handled by the shared side of the application — **Kotlin Multiplatform is simply beautiful!**
