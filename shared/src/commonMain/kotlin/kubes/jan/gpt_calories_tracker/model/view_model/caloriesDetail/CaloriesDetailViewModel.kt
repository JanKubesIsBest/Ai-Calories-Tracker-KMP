package kubes.jan.gpt_calories_tracker.model.view_model.caloriesDetail

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.launch
import kotlinx.datetime.DateTimeUnit
import kotlinx.datetime.Instant
import kotlinx.datetime.LocalDate
import kotlinx.datetime.LocalDateTime
import kotlinx.datetime.TimeZone
import kotlinx.datetime.number
import kotlinx.datetime.plus
import kotlinx.datetime.toInstant
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
                deleteMeal(caloriesDetailState.value.meal.id)
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
            is CaloriesDetailIntent.EditTime -> {
                println(caloriesDetailState.value.meal.date)
                val newDate = setDateTimeString(caloriesDetailState.value.meal.date, userIntent.hour, userIntent.minute)
                val newMeal = caloriesDetailState.value.meal.copy(date = newDate)

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

    fun setDateTimeString(dateTimeString: String, newHours: Int, newMinutes: Int): String {
        // Parse the input string (assumed to be in UTC) to an Instant
        val instant = Instant.parse(dateTimeString)
        println("Original Instant: $instant")

        // Convert to LocalDateTime in the system time zone
        val localDateTime = instant.toLocalDateTime(TimeZone.currentSystemDefault())
        println("LocalDateTime (System TZ): $localDateTime")

        // Update the LocalDateTime with new hours and minutes
        val updatedLocalDateTime = LocalDateTime(
            year = localDateTime.year,
            month = localDateTime.month,
            dayOfMonth = localDateTime.dayOfMonth,
            hour = newHours,
            minute = newMinutes,
            second = localDateTime.second,
            nanosecond = localDateTime.nanosecond
        )
        println("Updated LocalDateTime (System TZ): $updatedLocalDateTime")

        // Convert back to Instant using the system time zone
        val updatedInstant = updatedLocalDateTime.toInstant(TimeZone.currentSystemDefault())
        println("Updated UTC Instant: $updatedInstant")

        // Return the UTC Instant as a string
        return updatedInstant.toString()
    }

    private fun deleteMeal(id: Int) {
        database.deleteMealById(id)
    }

}

data class CaloriesDetailState(val meal: MealCaloriesDesc)

sealed class CaloriesDetailIntent {
    data object Delete: CaloriesDetailIntent()

    data class EditHeading(val newHeading: String): CaloriesDetailIntent()
    data class EditCalories(val newCalories: Int): CaloriesDetailIntent()
    data class EditTime(val hour: Int, val minute: Int): CaloriesDetailIntent()
}