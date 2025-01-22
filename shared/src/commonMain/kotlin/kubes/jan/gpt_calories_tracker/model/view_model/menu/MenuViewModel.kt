package kubes.jan.gpt_calories_tracker.model.view_model.menu

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.launch
import kotlinx.datetime.Clock
import kotlinx.datetime.DateTimeUnit
import kotlinx.datetime.TimeZone
import kotlinx.datetime.minus
import kotlinx.datetime.toLocalDateTime
import kubes.jan.gpt_calories_tracker.cache.Database
import kubes.jan.gpt_calories_tracker.database.entity.MealCaloriesDesc
import kubes.jan.gpt_calories_tracker.model.view_model.app_view_model.AppViewModel
import kubes.jan.gpt_calories_tracker.model.view_model.app_view_model.Event
import kubes.jan.gpt_calories_tracker.model.view_model.mealsInDay.MealsInDayIntent
import kubes.jan.gpt_calories_tracker.model.view_model.mealsInDay.getTotalCalories
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class MenuViewModel(private val database: Database,) : ViewModel(), KoinComponent {
    private val appViewModel: AppViewModel by inject()

    val menuState: MutableStateFlow<MenuViewModelState> = MutableStateFlow(
        MenuViewModelState(
            days = emptyList()
        )
    )

    init {
        menuState.value = menuState.value.copy(days = getPreviousDays())

        getAllDays()

        viewModelScope.launch {
            appViewModel.events.collect { event ->
                println("Collected: $event")
                when (event) {
                    Event.UpdateMeals -> {
                        getAllDays()
                    }
                    else -> {}
                }
            }
        }
    }

    fun processUserIntents(userIntent: MenuIntent) {
        when (userIntent) {
            is MenuIntent.GetDays -> {
                getAllDays()
            }
            /*
            * You can also handle other user intents such as GetUsers here
            * */
        }
    }

    private fun getAllDays() {
        var newDaysList = emptyList<Day>()

        menuState.value.days.forEach { day ->
            val meals = database.getMealByDate(day.date)
            val totalCalories = getTotalCalories(meals)

            var newDay = day.copy(meals = meals, totalCalories = totalCalories, description = "In the future, here will be description")
            newDaysList = newDaysList + newDay
        }

        menuState.value = menuState.value.copy(days = newDaysList)
    }

    private fun getPreviousDays(): List<Day> {
        val now = Clock.System.now()
        val today = now.toLocalDateTime(TimeZone.currentSystemDefault()).date

        return (0..10).map { i ->
            val thisDay = today.minus(i, DateTimeUnit.DAY)
            val title = if (i == 0){
                "Today"
            }
            else if (i <= 7) {
                thisDay.dayOfWeek.name.lowercase().replaceFirstChar { it.uppercaseChar() }
            } else {
                "${thisDay.dayOfMonth}.${thisDay.monthNumber}"
            }

            Day(
                date = thisDay.toString(),
                title = title,
                description = "",
                totalCalories = 0,
                meals = emptyList()
            )
        }
    }
}

data class MenuViewModelState(val days: List<Day>)

sealed class MenuIntent {
    data class GetDays(val desc: String) : MenuIntent()
}

data class Day(
    val date: String,
    val title: String,
    val description: String,
    val totalCalories: Int,
    val meals: List<MealCaloriesDesc>
)