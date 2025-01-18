package kubes.jan.gpt_calories_tracker.model.view_model.menu

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.datetime.Clock
import kotlinx.datetime.DateTimeUnit
import kotlinx.datetime.TimeZone
import kotlinx.datetime.minus
import kotlinx.datetime.toLocalDateTime
import kubes.jan.gpt_calories_tracker.model.view_model.app_view_model.AppViewModel
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class MenuViewModel() : ViewModel(), KoinComponent {
    private val appViewModel: AppViewModel by inject()

    val menuState: MutableStateFlow<MenuViewModelState> = MutableStateFlow(
        MenuViewModelState(
            days = emptyList()
        )
    )

    init {
        menuState.value = menuState.value.copy(days = getPreviousDays())
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
                description = thisDay.toString(),
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
)