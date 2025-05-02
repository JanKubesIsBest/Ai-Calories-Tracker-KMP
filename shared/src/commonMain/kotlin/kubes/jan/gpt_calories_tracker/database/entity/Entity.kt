package kubes.jan.gpt_calories_tracker.database.entity

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class MealCaloriesDesc(
    @SerialName("id")
    val id: Int,
    @SerialName("heading")
    val heading: String,
    @SerialName("description")
    val description: String,
    @SerialName("date")
    val date: String,
    @SerialName("user_description")
    val userDescription: String,
    @SerialName("total_calories")
    val totalCalories: Int,
)

@Serializable
data class MealCaloriesDescGPT(
    @SerialName("heading")
    val heading: String,
    @SerialName("description")
    val description: String,
    @SerialName("date")
    val date: String,
    @SerialName("user_description")
    val userDescription: String,
    @SerialName("total_calories")
    val totalCalories: Int,
)

@Serializable
data class UserInfo(
    val id: Long? = null,
    val gender: String? = null,
    val weight: Int? = null,
    val build: String? = null,
    val country: String? = null
)