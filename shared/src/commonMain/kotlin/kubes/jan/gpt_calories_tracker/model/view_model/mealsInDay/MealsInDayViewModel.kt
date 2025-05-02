package kubes.jan.gpt_calories_tracker.model.view_model.mealsInDay

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

import kubes.jan.gpt_calories_tracker.model.networking.UseCases.GetMealCaloriesUseCase
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.datetime.Clock
import kotlinx.datetime.Instant
import kotlinx.datetime.TimeZone
import kotlinx.datetime.toLocalDateTime
import kubes.jan.gpt_calories_tracker.cache.Database
import kubes.jan.gpt_calories_tracker.database.entity.MealCaloriesDesc
import kubes.jan.gpt_calories_tracker.database.entity.MealCaloriesDescGPT
import kubes.jan.gpt_calories_tracker.model.view_model.app_view_model.AppViewModel
import kubes.jan.gpt_calories_tracker.model.view_model.app_view_model.Event
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject
import kotlin.time.Duration.Companion.minutes

class MealsInDayViewModel(private val database: Database, private val date: String) : ViewModel(),
    KoinComponent {
    private val appViewModel: AppViewModel by inject()

    private val _mealsInDayState: MutableStateFlow<MealsInDayState> = MutableStateFlow(
        MealsInDayState(
            meals = emptyList(),
            mealSections = emptyList(),
            mealDescription = "",
            totalCalories = 0,
            mealAddedError = MealAddedError.NONE
        )
    )

    val mealsInDayState: StateFlow<MealsInDayState> = _mealsInDayState.asStateFlow()

    init {
        println("INIT MealsInDayViewModel")
        getAllMeals()

        viewModelScope.launch {
            appViewModel.events.collect { event ->
                println("Collected: $event")
                when (event) {
                    Event.UpdateMeals -> getAllMeals()
                    else -> {}
                }
            }
        }
    }

    private fun currentViewState(): MealsInDayState {
        return _mealsInDayState.value
    }

    private fun getAllMeals() {
        val newMeals = database.getMealByDate(date)
        println(groupMealsByTimeDifference(newMeals))
        _mealsInDayState.value = _mealsInDayState.value.copy(
            meals = newMeals,
            mealSections = groupMealsByTimeDifference(newMeals),
            totalCalories = getTotalCalories(newMeals)
        )
    }

    fun processUserIntents(userIntent: MealsInDayIntent) {
        when (userIntent) {
            is MealsInDayIntent.AddMeal -> addNewMeal(userIntent.desc)
            is MealsInDayIntent.GetAllMeals -> getAllMeals()
            is MealsInDayIntent.ErrorMessageDismissed -> {
                println("Error Message Dismissed")
            }
        }
    }

    private fun addNewMeal(mealDesc: String) {
        // Create a placeholder meal with "Loading..." description
        val placeholderMeal = MealCaloriesDesc(
            id = -1, // Temporary ID to indicate it's not in the database yet
            heading = mealDesc,
            description = "Loading...",
            date = Clock.System.now().toString(),
            userDescription = mealDesc,
            totalCalories = 0
        )

        // Add the placeholder to the meals list and get its index
        val currentMeals = currentViewState().meals
        val updatedMeals = currentMeals + placeholderMeal
        val placeholderIndex = updatedMeals.lastIndex // Index of the newly added meal

        // Update the state immediately
        _mealsInDayState.value = _mealsInDayState.value.copy(
            meals = updatedMeals,
            mealSections = groupMealsByTimeDifference(updatedMeals),
            totalCalories = getTotalCalories(updatedMeals)
        )

        // Launch network request in the background
        viewModelScope.launch {
            val getter = GetMealCaloriesUseCase()
            getter.invoke(mealDesc)
                .onSuccess { result ->
                    // Replace the placeholder with real data at the same index
                    addNewMealToTheList(result, placeholderIndex)
                }
                .onFailure {
                    removeMeal(placeholderIndex)
                }
        }
    }

    private fun addNewMealToTheList(meal: MealCaloriesDescGPT, indexToUpdate: Int? = null) {
        val databaseMeal = MealCaloriesDesc(
            id = 0,
            heading = meal.heading,
            date = meal.date,
            description = meal.description,
            totalCalories = meal.totalCalories,
            userDescription = meal.userDescription
        )
        val idOfThisMeal = database.insertMeal(databaseMeal)
        val newMeal = databaseMeal.copy(id = idOfThisMeal)

        val currentMeals = currentViewState().meals
        val updatedMeals = if (indexToUpdate != null && indexToUpdate in currentMeals.indices) {
            currentMeals.toMutableList().apply { this[indexToUpdate] = newMeal }
        } else {
            currentMeals + newMeal
        }

        _mealsInDayState.value = _mealsInDayState.value.copy(
            meals = updatedMeals,
            mealSections = groupMealsByTimeDifference(updatedMeals),
            totalCalories = getTotalCalories(updatedMeals)
        )

        viewModelScope.launch {
            appViewModel.postEvent(Event.UpdateMeals)
        }
    }

    private fun removeMeal(indexToDelete: Int) {
        val currentMeals = currentViewState().meals

        val updatedMeals = currentMeals.toMutableList().apply {
            removeAt(indexToDelete)
        }

        _mealsInDayState.value = _mealsInDayState.value.copy(
            meals = updatedMeals,
            mealSections = groupMealsByTimeDifference(updatedMeals),
            totalCalories = getTotalCalories(updatedMeals)
        )
    }

    companion object {
        fun groupMealsByTimeDifference(meals: List<MealCaloriesDesc>): List<MealSection> {
            val sortedMeals = meals.sortedBy { Instant.parse(it.date) }
            val mealSections = mutableListOf<MealSection>()
            val currentSectionMeals = mutableListOf<MealCaloriesDesc>()
            var lastMealTime: Instant? = null

            for (meal in sortedMeals) {
                val mealTime = Instant.parse(meal.date)
                if (lastMealTime == null || mealTime - lastMealTime >= 30.minutes) {
                    if (currentSectionMeals.isNotEmpty()) {
                        val czechTimeZone = TimeZone.of("Europe/Prague")
                        val headingTime = Instant.parse(currentSectionMeals[0].date)
                            .toLocalDateTime(czechTimeZone)
                        mealSections.add(
                            MealSection(
                                meals = currentSectionMeals.toList(),
                                sectionName = "${headingTime.hour}:${
                                    headingTime.minute.toString().padStart(2, '0')
                                }"
                            )
                        )
                        currentSectionMeals.clear()
                    }
                    currentSectionMeals.add(meal)
                    lastMealTime = mealTime
                } else {
                    currentSectionMeals.add(meal)
                }
            }

            if (currentSectionMeals.isNotEmpty()) {
                val czechTimeZone = TimeZone.of("Europe/Prague")
                val headingTime =
                    Instant.parse(currentSectionMeals[0].date).toLocalDateTime(czechTimeZone)
                mealSections.add(
                    MealSection(
                        meals = currentSectionMeals.toList(),
                        sectionName = "${headingTime.hour}:${
                            headingTime.minute.toString().padStart(2, '0')
                        }"
                    )
                )
            }

            return mealSections
        }
    }
}

fun getTotalCalories(meals: List<MealCaloriesDesc>): Int {
    var _totalCalories = 0
    meals.forEach { x ->
        _totalCalories += x.totalCalories
    }
    return _totalCalories
}

data class MealsInDayState(
    val meals: List<MealCaloriesDesc>,
    val mealSections: List<MealSection>,
    val mealDescription: String,
    val totalCalories: Int,

    val mealAddedError: MealAddedError
)

sealed class MealsInDayIntent {
    data class AddMeal(val desc: String) : MealsInDayIntent()
    data object GetAllMeals : MealsInDayIntent()
    data object ErrorMessageDismissed: MealsInDayIntent()
}

enum class MealAddedError {
    NONE, ERROR
}

data class MealSection(val meals: List<MealCaloriesDesc>, val sectionName: String) {
    fun totalCalories(): Int {
        return meals.sumOf { it.totalCalories }
    }
}