package kubes.jan.gpt_calories_tracker.model.view_model.menu

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kubes.jan.gpt_calories_tracker.model.networking.UseCases.GetMealCaloriesUseCase
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import kubes.jan.gpt_calories_tracker.cache.Database
import kubes.jan.gpt_calories_tracker.database.entity.MealCaloriesDesc
import kubes.jan.gpt_calories_tracker.database.entity.MealCaloriesDescGPT
import kubes.jan.gpt_calories_tracker.model.view_model.app_view_model.AppViewModel
import kubes.jan.gpt_calories_tracker.model.view_model.app_view_model.Event
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class MenuViewModel(private val database: Database) : ViewModel(), KoinComponent {
    private val appViewModel: AppViewModel by inject()

    val menuViewModelState: MutableStateFlow<MenuViewState> = MutableStateFlow(
        MenuViewState(
            emptyList(),
            "",
            0
        ),
    )

    init {
        println("INIT MENUVIEWMODEL")
        // Init state of the database
        getAllMeals()

        viewModelScope.launch {
            appViewModel.events.collect { event ->
                println("Collected: $event")
                when (event) {
                    is Event.DeleteEvent -> deleteEvent(event.id)
                }
            }
        }
    }

    // Get the current current view state to used in processUserIntents
    private fun currentViewState(): MenuViewState {
        return menuViewModelState.value
    }

    private fun getAllMeals() {
        val newMeals = database.getAllMeals()
        menuViewModelState.value = menuViewModelState.value.copy(meals = newMeals, totalCalories = getTotalCalories(newMeals))
    }

    // Process the user intent from View
    fun processUserIntents(userIntent: MenuIntent) {
        when (userIntent) {
            is MenuIntent.AddMeal -> {
                addNewMeal(userIntent.desc)
            }
            is MenuIntent.GetAllMeals -> {
                getAllMeals()
            }
            /*
            * You can also handle other user intents such as GetUsers here
            * */
        }
    }

    private fun deleteEvent(id: Int) {
        println("Deleting")
        database.deleteMealById(id)
        println("Deleted " + id.toString())

        // Filters out everything that does not have that id -> removes it
        val newList = menuViewModelState.value.meals.filter { it.id != id }

        menuViewModelState.value = menuViewModelState.value.copy(meals = newList, totalCalories = getTotalCalories(newList))
    }

    private fun addNewMealToTheList(meal: MealCaloriesDescGPT) {
        val databaseMeal: MealCaloriesDesc = MealCaloriesDesc(
            id = 0,
            heading = meal.heading,
            date = meal.date,
            description = meal.description,
            totalCalories = meal.totalCalories,
            userDescription = meal.userDescription
        )
        val idOfThisMeal = database.insertMeal(databaseMeal)

        println("Last inserted meal id: " + idOfThisMeal)
        val newMeal = databaseMeal.copy(id = idOfThisMeal)


        menuViewModelState.value = menuViewModelState.value.copy(
            meals = menuViewModelState.value.meals + newMeal,
            totalCalories = getTotalCalories(menuViewModelState.value.meals + newMeal
            )
        ) // Update state of calories as well
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
    data object GetAllMeals: MenuIntent()
}