package kubes.jan.gpt_calories_tracker.model.view_model.menu

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kubes.jan.gpt_calories_tracker.model.networking.UseCases.GetMealCaloriesUseCase
import kubes.jan.gpt_calories_tracker.model.networking.UseCases.MealCaloriesDesc
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch

class MenuViewModel() : ViewModel() {
    val menuViewModelState: MutableStateFlow<MenuViewState> = MutableStateFlow(MenuViewState(
        emptyList(), ""))

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
        menuViewModelState.value = menuViewModelState.value.copy(meals = menuViewModelState.value.meals + meal,)
    }

    private fun addNewMeal (mealDesc: String) {
        viewModelScope.launch {
            val getter = GetMealCaloriesUseCase()

            getter.invoke(mealDesc).onSuccess { result ->
                addNewMealToTheList(result)
            }
        }
    }

    fun getTotalCalories(): Int {
        var totalCalories = 0

        menuViewModelState.value.meals.forEach { x ->
            totalCalories += x.calories
        }

        return totalCalories
    }
}

data class MenuViewState(val meals: List<MealCaloriesDesc>, val mealDescription: String)

sealed class MenuIntent {
    data class AddMeal(val desc: String) : MenuIntent()
    // You also can other user intents such as GetUsers
}