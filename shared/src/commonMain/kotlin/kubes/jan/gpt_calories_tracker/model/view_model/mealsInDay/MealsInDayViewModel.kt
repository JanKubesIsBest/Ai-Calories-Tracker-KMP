package kubes.jan.gpt_calories_tracker.model.view_model.mealsInDay

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kubes.jan.gpt_calories_tracker.model.networking.UseCases.GetMealCaloriesUseCase
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch
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

class MealsInDayViewModel(private val database: Database) : ViewModel(), KoinComponent {
    private val appViewModel: AppViewModel by inject()

    val mealsInDayState: MutableStateFlow<MealsInDayState> = MutableStateFlow(
        MealsInDayState(
            emptyList(),
            emptyList(),
            "",
            0
        ),
    )

    init {
        println("INIT MealsInDayViewModel")
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
    private fun currentViewState(): MealsInDayState {
        return mealsInDayState.value
    }

    private fun getAllMeals() {
        val newMeals = database.getAllMeals()

        println(groupMealsByTimeDifference(newMeals))

        mealsInDayState.value = mealsInDayState.value.copy(
            meals = newMeals,
            mealSections = groupMealsByTimeDifference(newMeals),
            totalCalories = getTotalCalories(newMeals),
            )
    }

    // Process the user intent from View
    fun processUserIntents(userIntent: MealsInDayIntent) {
        when (userIntent) {
            is MealsInDayIntent.AddMeal -> {
                addNewMeal(userIntent.desc)
            }
            is MealsInDayIntent.GetAllMeals -> {
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
        val newList = mealsInDayState.value.meals.filter { it.id != id }

        mealsInDayState.value = mealsInDayState.value.copy(
            meals = newList,
            mealSections = groupMealsByTimeDifference(newList),
            totalCalories = getTotalCalories(newList),
            )
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

        val newMeal = databaseMeal.copy(id = idOfThisMeal)


        mealsInDayState.value = mealsInDayState.value.copy(
            meals = mealsInDayState.value.meals + newMeal,
            mealSections = groupMealsByTimeDifference(mealsInDayState.value.meals + newMeal),
            totalCalories = getTotalCalories(mealsInDayState.value.meals + newMeal
            )
        ) // Update state of calories as well
    }

    private fun addNewMeal(mealDesc: String) {
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

    private fun groupMealsByTimeDifference(meals: List<MealCaloriesDesc>): List<MealSection> {
        // Parse ISO 8601 timestamps and sort meals chronologically
        val sortedMeals = meals.sortedBy { Instant.parse(it.date) }
        val mealSections = mutableListOf<MealSection>()
        val currentSectionMeals = mutableListOf<MealCaloriesDesc>()
        var lastMealTime: Instant? = null

        for (meal in sortedMeals) {
            val mealTime = Instant.parse(meal.date)
            if (lastMealTime == null || mealTime - lastMealTime >= 30.minutes) {
                // If there's already a section, save it before starting a new one
                if (currentSectionMeals.isNotEmpty()) {
                    val czechTimeZone = TimeZone.of("Europe/Prague")
                    val headingTime = Instant.parse(currentSectionMeals[0].date).toLocalDateTime(czechTimeZone)
                    mealSections.add(
                        MealSection(
                            meals = currentSectionMeals.toList(),
                            // The first meal in the section will set the heading of the section -> time when it was eaten
                            sectionName = headingTime.hour.toString() + ":" + headingTime.minute.toString()
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

        // Add the last section if it's not empty
        if (currentSectionMeals.isNotEmpty()) {
            val czechTimeZone = TimeZone.of("Europe/Prague")
            val headingTime = Instant.parse(currentSectionMeals[0].date).toLocalDateTime(czechTimeZone)
            mealSections.add(
                MealSection(
                    meals = currentSectionMeals.toList(),
                    sectionName = headingTime.hour.toString() + ":" + headingTime.minute.toString()
                )
            )
        }

        return mealSections
    }
}

data class MealsInDayState(val meals: List<MealCaloriesDesc>, val mealSections: List<MealSection>, val mealDescription: String, val totalCalories: Int)

sealed class MealsInDayIntent {
    data class AddMeal(val desc: String) : MealsInDayIntent()
    // You also can other user intents such as GetUsers
    data object GetAllMeals: MealsInDayIntent()
}

data class MealSection(val meals: List<MealCaloriesDesc>, val sectionName: String)