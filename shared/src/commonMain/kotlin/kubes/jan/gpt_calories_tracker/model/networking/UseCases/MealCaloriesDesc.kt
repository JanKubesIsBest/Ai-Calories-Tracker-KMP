package kubes.jan.gpt_calories_tracker.model.networking.UseCases

import kotlinx.serialization.Serializable

@Serializable
data class MealCaloriesDesc(
    val description: String,
    val calories: Int,
    val heading: String
)
