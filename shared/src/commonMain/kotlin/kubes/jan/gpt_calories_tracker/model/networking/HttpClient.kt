package kubes.jan.gpt_calories_tracker.model.networking

import io.ktor.client.HttpClient
import io.ktor.client.plugins.contentnegotiation.ContentNegotiation
import io.ktor.client.request.accept
import io.ktor.client.request.header
import io.ktor.client.request.post
import io.ktor.client.request.setBody
import io.ktor.client.statement.HttpResponse
import io.ktor.client.statement.bodyAsText
import io.ktor.http.ContentType
import io.ktor.http.contentType
import io.ktor.serialization.kotlinx.json.json
import kotlinx.datetime.Clock
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import kubes.jan.gpt_calories_tracker.database.entity.MealCaloriesDesc
import kubes.jan.gpt_calories_tracker.database.entity.MealCaloriesDescGPT

class MyHttpClient {
    private val client = HttpClient {
        install(ContentNegotiation) {
            json()
        }
    }

    suspend fun GetCalories(mealDesc: String): Result<MealCaloriesDescGPT> {
        val currentMoment = Clock.System.now().toString()

        val requestBody = MealRequestBody(
            model = "meta-llama/Meta-Llama-3.1-70B-Instruct-Turbo",
            messages = listOf(
                Message(
                    role = "system",
                    content = "This is a description of a meal I just ate: '$mealDesc' I want you to write a JSON file that contains 'heading', which is a max three word name of the meal, then 'description', this should contain how you imagine the meal and the 'total_calories', which is a Int which contains your prediction on how much calories the meal could have. Alsi, it should have 'user_description', which is going to be simply: '$mealDesc' and 'date', which is: '$currentMoment' Write ONLY the JSON file, nothing else. Start with { and end with } for proper json file."
                )
            )
        )

        val response: HttpResponse = client.post("https://api.together.xyz/v1/chat/completions") {
            contentType(ContentType.Application.Json)
            accept(ContentType.Application.Json)
            header("authorization", "Bearer 9084a526808152ccd5058573c899c82d52fc9ee4da4788e4d6dca5126d772754")
            setBody(requestBody)
        }

        val rawJson = response.bodyAsText()
        println("Raw JSON response: $rawJson")

        // We don't need every parameter in the response, thus we take only few of them with this
        val json = Json {
            ignoreUnknownKeys = true // Ignore keys not defined in data classes
        }

        val topLevelResponse = json.decodeFromString<TopLevelResponse>(rawJson)

        val contentJson = topLevelResponse.choices.first().message.content.trim('`', '\n')

        val mealCaloriesDesc = Json.decodeFromString<MealCaloriesDescGPT>(contentJson)

        return Result.success(
            mealCaloriesDesc
        )
    }
}

@Serializable
data class MealRequestBody(
    val model: String,
    val messages: List<Message>
)

@Serializable
data class TopLevelResponse(
    val choices: List<Choice>
)

@Serializable
data class Choice(
    val message: Message
)

@Serializable
data class Message(
    val role: String,
    val content: String
)

