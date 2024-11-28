package kubes.jan.gpt_calories_tracker.model.view_model.menu

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kubes.jan.gpt_calories_tracker.model.networking.UseCases.GetMealCaloriesUseCase
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch
import kubes.jan.gpt_calories_tracker.cache.Database
import kubes.jan.gpt_calories_tracker.database.entity.MealCaloriesDesc

class MenuViewModel(private val database: Database) : ViewModel() {
    val menuViewModelState: MutableStateFlow<MenuViewState> = MutableStateFlow(
        MenuViewState(
            emptyList(),
            "",
            0
        ),
    )

    init {
        // Init state of the database
        val newMeals = database.getAllMeals()
        menuViewModelState.value = menuViewModelState.value.copy(meals = newMeals, totalCalories = getTotalCalories(newMeals))
    }

    // Get the current current view state to used in processUserIntents
    private fun currentViewState(): MenuViewState {
        return menuViewModelState.value
    }

    // Process the user intent from View
    fun processUserIntents(userIntent: MenuIntent) {
        when (userIntent) {
            is MenuIntent.AddMeal -> {
                addNewMeal(userIntent.desc)
            }
            /*
            * You can also handle other user intents such as GetUsers here
            * */
        }
    }

    private fun addNewMealToTheList(meal: MealCaloriesDesc) {
        database.insertMeal(meal)
        menuViewModelState.value = menuViewModelState.value.copy(meals = menuViewModelState.value.meals + meal, totalCalories = getTotalCalories(menuViewModelState.value.meals + meal)) // Update state of calories as well
    }

    private fun addNewMeal (mealDesc: String) {
        viewModelScope.launch {
            val getter = GetMealCaloriesUseCase()

            getter.invoke(mealDesc).onSuccess { result ->
                addNewMealToTheList(result)
            }
        }
    }

    private fun getTotalCalories(meals: List<MealCaloriesDesc>): Int {
        var _totalCalories = 0
        
        meals.forEach { x ->
            _totalCalories += x.totalCalories
        }

        return _totalCalories
    }
}

data class MenuViewState(val meals: List<MealCaloriesDesc>, val mealDescription: String, val totalCalories: Int)

sealed class MenuIntent {
    data class AddMeal(val desc: String) : MenuIntent()
    // You also can other user intents such as GetUsers
}