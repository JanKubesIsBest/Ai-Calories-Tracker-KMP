package kubes.jan.gpt_calories_tracker.model.view_model.caloriesDetail

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kubes.jan.gpt_calories_tracker.cache.Database
import kubes.jan.gpt_calories_tracker.database.entity.MealCaloriesDesc

class CaloriesDetailViewModel(private val database: Database, private val meal: MealCaloriesDesc) : ViewModel()  {
    val caloriesDetailState: MutableStateFlow<CaloriesDetailState> = MutableStateFlow(
        CaloriesDetailState(
            meal = meal
        )
    )

    fun processUserIntents(userIntent: CaloriesDetailIntent) {
        when (userIntent) {
            is CaloriesDetailIntent.Delete -> {

            }
            /*
            * You can also handle other user intents such as GetUsers here
            * */
        }
    }

}

data class CaloriesDetailState(val meal: MealCaloriesDesc)

sealed class CaloriesDetailIntent {
    object Delete: CaloriesDetailIntent()
    // You also can other user intents such as GetUsers
}