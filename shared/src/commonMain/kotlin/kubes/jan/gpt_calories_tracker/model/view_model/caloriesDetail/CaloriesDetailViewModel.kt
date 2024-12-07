package kubes.jan.gpt_calories_tracker.model.view_model.caloriesDetail

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kubes.jan.gpt_calories_tracker.cache.Database
import kubes.jan.gpt_calories_tracker.database.entity.MealCaloriesDesc
import kubes.jan.gpt_calories_tracker.model.view_model.app_view_model.AppViewModel
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class CaloriesDetailViewModel(private val database: Database, private val meal: MealCaloriesDesc) : ViewModel(), KoinComponent {
    private val appViewModel: AppViewModel by inject()

    init {
        appViewModel.counter += 1

        println(appViewModel.counter)
    }

    val caloriesDetailState: MutableStateFlow<CaloriesDetailState> = MutableStateFlow(
        CaloriesDetailState(
            meal = meal
        )
    )

    fun processUserIntents(userIntent: CaloriesDetailIntent) {
        when (userIntent) {
            is CaloriesDetailIntent.Delete -> {
                database.deleteMealById(caloriesDetailState.value.meal.id)
            }
            /*
            * You can also handle other user intents such as GetUsers here
            * */
        }
    }

}

data class CaloriesDetailState(val meal: MealCaloriesDesc)

sealed class CaloriesDetailIntent {
    data object Delete: CaloriesDetailIntent()
    // You also can other user intents such as GetUsers
}