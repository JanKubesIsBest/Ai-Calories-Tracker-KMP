package kubes.jan.gpt_calories_tracker.model.view_model.menu

import androidx.lifecycle.ViewModel
import kubes.jan.gpt_calories_tracker.cache.Database
import kubes.jan.gpt_calories_tracker.database.entity.MealCaloriesDesc
import kubes.jan.gpt_calories_tracker.model.view_model.app_view_model.AppViewModel
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class MenuViewModel(private val database: Database) : ViewModel(), KoinComponent {
    private val appViewModel: AppViewModel by inject()

}

data class MenuViewModelState(val days: List<Day>)

sealed class MenuIntent {
    data class GetDays(val desc: String) : MenuIntent()
}

data class Day(
    val date: String,
    val description: String,
)