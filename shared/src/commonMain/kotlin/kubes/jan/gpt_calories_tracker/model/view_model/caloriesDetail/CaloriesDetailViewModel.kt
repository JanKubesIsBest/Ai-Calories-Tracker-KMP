package kubes.jan.gpt_calories_tracker.model.view_model.caloriesDetail

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch
import kotlinx.datetime.Instant
import kotlinx.datetime.LocalDate
import kotlinx.datetime.LocalDateTime
import kotlinx.datetime.TimeZone
import kotlinx.datetime.number
import kotlinx.datetime.toLocalDateTime
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
                    appViewModel.postEvent(Event.UpdateMeals)
                }
            }

            is CaloriesDetailIntent.EditCalories -> {
                println(userIntent.newCalories)

                val newMeal = caloriesDetailState.value.meal.copy(totalCalories = userIntent.newCalories)

                database.editMealById(newMeal)

                caloriesDetailState.value = caloriesDetailState.value.copy(meal = newMeal)

                viewModelScope.launch {
                    appViewModel.postEvent(Event.UpdateMeals)
                }
            }
            is CaloriesDetailIntent.EditHeading -> {
                println(userIntent.newHeading)

                val newMeal = caloriesDetailState.value.meal.copy(heading = userIntent.newHeading)

                database.editMealById(newMeal)

                caloriesDetailState.value = caloriesDetailState.value.copy(meal = newMeal)

                viewModelScope.launch {
                    appViewModel.postEvent(Event.UpdateMeals)
                }
            }
        }
    }

    fun dateToStringFormat(): String {
        val datetimeDate = Instant.parse(caloriesDetailState.value.meal.date)

        val date: LocalDate = datetimeDate.toLocalDateTime(TimeZone.currentSystemDefault()).date
        return date.dayOfMonth.toString() + "." + date.month.number.toString() + "." + date.year.toString()
    }

    fun timeToStringFormat(): String {
        val datetimeDate = Instant.parse(caloriesDetailState.value.meal.date)
        val time = datetimeDate.toLocalDateTime(TimeZone.currentSystemDefault()).time

        val string = time.hour.toString() + ":"
        println(time.minute.toString())
        if (time.minute.toString().length < 2) {
            return string + "0" + time.minute.toString()
        } else {
            return string + time.minute.toString()
        }
    }

}

data class CaloriesDetailState(val meal: MealCaloriesDesc)

sealed class CaloriesDetailIntent {
    data object Delete: CaloriesDetailIntent()

    data class EditHeading(val newHeading: String): CaloriesDetailIntent()
    data class EditCalories(val newCalories: Int): CaloriesDetailIntent()
}