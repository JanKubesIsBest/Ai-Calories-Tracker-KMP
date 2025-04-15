# App Overview - the purpose.
There are two resons I have started developing this app: 
- Learn kotlin Multiplatform
  - I feel that Kotlin Multiplatform is the future - it combines the native ui, allowing for smooth expiriance, with shared logic, allowing faster development.
  - I still see a place for Flutter, but while I worked in NFCtron I saw the opourtunity in this KMP as well.
  - I wrote about this opourtunity a little in my more financed focused article on X [here]([url](https://x.com/_Kubes_Jan/status/1901003267183698324)).
- Explore the possibities of using LLM to track your calories in take.
  - Although taking picture of your food, as explored by many apps already, might seem easier at first, the text expiriance feels not only more private, but also allows more description for the model to assess the total calories count.
 
## App overview - the project design
Although this is a project I work on alongside school and other smaller projects, I think it is much better to have basic designs in Figma as well. This allowed me to asses whatever or not I really want to work on the thing. 

I also try to keep the Apple's design language, while bringing new, in my view more user friendly features. This is visible for example in the add new meal view. The typical Apple approach, as seen in the notes menu app, would be to add small **+ button in the right corner**. This feels very unintuitive when you realize that this is the most used button in the notes menu screen. **That's why I decided to use huge *Add new meal* button, which expands into input.** This design feature is inspired by the Arc search, which uses something similiar.

<img width="402" alt="Image" src="https://github.com/user-attachments/assets/56abade6-8cda-43c5-af16-183b7396272e" />
<br/>

*Snapshot from Figma*

## How app looks right now. 
The app is developed only for iOS. Right now, the core logic is working: **Add a new meal -> store it -> display total calories -> edit previous meals**.

Enjoy the simple user flow avaiable shown right here:
![Image](https://github.com/user-attachments/assets/e1de82c5-8d54-4a3d-8f33-d4a6ae24210d)

## How app looks inside.
If you would like to examine the app a little more, I have tried to stick to the simple commiting system:
- Feat - new feature
- Fix - fixing some bugs

- Then parentheses containing either *Shared*, *iOS*, or **both**. This way you can quickly look on the specific changes in the app's structure.
- Followed by the exact description of fix/feature
### Shared:
The structure is quite simple. 

I am using SQLDelight. Every function needed to operate is in the Database class. This class is then accessed by the view models (*which are shared*). The same goes for the networking, which is done through the useCases. Only use case right now is asking LLM how many calories is in the meal. LLM returns JSON, which is parsed to an Meal instance. 

<img width="402" alt="Image" src="https://github.com/user-attachments/assets/26ae1859-3323-46c1-87c0-d73d6549fdfa" />

Let's look at view model example. 
<img width="1815" alt="Image" src="https://github.com/user-attachments/assets/c67d10d3-dc43-4d1f-ad01-73a6258f5db1" />

Almost every view model can acess AppViewModel, which is crucial for managing the state in the entire application and is injected using Koin. This view model is used in order to update state between different view models. This way, I can for example update the state in the day screen (*the screen where I can see which meals I ate*) when I delete a meal in the meal detail view. 

### Ui 
<img width="2272" alt="Image" src="https://github.com/user-attachments/assets/5934319c-ae34-4247-b758-71215fe1c54a" />

Every screen is written natively with Swift UI. To work with State in swift, I am using Skia, which is by far most easiest integration for managing state in KMP applications. 

The swift code is quite simple, because every more *complex* functionality is written in Kotlin and I just access these through the view models. Let's look at the example here: 
```
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
}
```

The main execution is simply done through: `viewModel.processUserIntents(userIntent: MealsInDayIntent.AddMeal(desc: newMeal))`

And that's about it for now. This was just quick review, in the future, I might make the app avaiable on App Store. Thanks!
