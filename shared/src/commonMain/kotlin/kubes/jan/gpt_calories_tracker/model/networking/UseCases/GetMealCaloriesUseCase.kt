package kubes.jan.gpt_calories_tracker.model.networking.UseCases

import kubes.jan.gpt_calories_tracker.database.entity.MealCaloriesDesc
import kubes.jan.gpt_calories_tracker.database.entity.MealCaloriesDescGPT
import kubes.jan.gpt_calories_tracker.model.networking.MyHttpClient

class GetMealCaloriesUseCase {
    private val httpClient = MyHttpClient()
    suspend fun invoke(mealDesc: String): Result<MealCaloriesDescGPT> {
        return httpClient.GetCalories(mealDesc)
    }
}