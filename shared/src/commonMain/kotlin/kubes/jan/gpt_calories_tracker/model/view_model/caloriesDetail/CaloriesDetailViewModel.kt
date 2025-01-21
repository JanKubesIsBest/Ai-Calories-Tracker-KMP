package kubes.jan.gpt_calories_tracker.model.view_model.caloriesDetail

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch
import kotlinx.datetime.Instant
import kotlinx.datetime.LocalDateTime
import kubes.jan.gpt_calories_tracker.cache.Database
import kubes.jan.gpt_calories_tracker.database.entity.MealCaloriesDesc
import kubes.jan.gpt_calories_tracker.model.view_model.app_view_model.AppViewModel
import kubes.jan.gpt_calories_tracker.model.view_model.app_view_model.Event
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class CaloriesDetailViewModel(private val database: Database, private val meal: MealCaloriesDesc) : ViewModel(), KoinComponent {
    private val appViewModel: AppViewModel by inject()

    val caloriesDetailState: MutableStateFlow<CaloriesDetailState> = MutableStateFlow(
        CaloriesDetailState(
            meal = meal
        )
    )

    fun processUserIntents(userIntent: CaloriesDetailIntent) {
        when (userIntent) {
            is CaloriesDetailIntent.Delete -> {
                viewModelScope.launch {
                    appViewModel.postEvent(Event.DeleteEvent(meal.id))
                }
            }
            /*
            * You can also handle other user intents such as GetUsers here
            * */
        }
    }

    fun dateToStringFormat(): String {
        val datetimeDate = LocalDateTime.parse(meal.date)

        return datetimeDate.dayOfMonth.toString() + "." + datetimeDate.month.toString() + "." + datetimeDate.year.toString()
    }

    fun timeToStringFormat(): String {
        val datetimeDate = LocalDateTime.parse(meal.date)
        val string = datetimeDate.hour.toString() + ":"

        if (datetimeDate.minute.toString().length < 2) {
            return string + "0" + datetimeDate.minute.toString()
        } else {
            return string + datetimeDate.minute.toString().length
        }
    }

}

data class CaloriesDetailState(val meal: MealCaloriesDesc)

sealed class CaloriesDetailIntent {
    data object Delete: CaloriesDetailIntent()
    // You also can other user intents such as GetUsers
}