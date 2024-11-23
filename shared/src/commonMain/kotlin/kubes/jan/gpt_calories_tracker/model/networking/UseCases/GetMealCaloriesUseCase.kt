package kubes.jan.gpt_calories_tracker.model.networking.UseCases

import kotlinx.coroutines.runBlocking
import kubes.jan.gpt_calories_tracker.model.networking.MyHttpClient

class GetMealCaloriesUseCase {
    private val httpClient = MyHttpClient()
    suspend fun invoke(mealDesc: String): Result<MealCaloriesDesc> {
        return httpClient.GetCalories(mealDesc)
    }
}