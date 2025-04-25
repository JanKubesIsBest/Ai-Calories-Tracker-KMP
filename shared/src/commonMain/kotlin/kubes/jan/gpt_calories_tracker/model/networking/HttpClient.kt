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
import kotlinx.serialization.SerializationException
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
            model = "meta-llama/Meta-Llama-3.1-405B-Instruct-Turbo", // meta-llama/Llama-3.2-11B-Vision-Instruct-Turbo
            messages = listOf(
                Message(
                    role = "system",
                    content = "This is a description of a meal I just ate: '$mealDesc' I want you to write a J" +
                            "SON file that contains 'heading', which is a max three word name of the meal (Do not make things up, generally name things how the user named them, don't add anything yourself, The only thing you could add is the time of the day the user ate it, such as breakfast, lunch or dinner), then 'description', this should contain how you imagine the meal (again, don't make anything up. You can add few words about how you imagine it, but don't add anything specific that user did not tell you) and the 'total_calories', which is an Int which contains your prediction on how much kcal the meal could have. Also, it should have 'user_description', which is going to be simply: '$mealDesc' and 'date', which is: '$currentMoment' Write ONLY the JSON file, nothing else. Do not hallucinate. Start with { and end with } for proper json file." +
                            "" +
                            // TODO: REMOVE THE CZECHIA ("PLACING STRONG EMPHASIS ON THE FACT THAT THEY ARE FROM CZECHIA)
                            "You should consider the user's specific context, placing strong emphasis on the fact that they are in Czechia, where portion sizes and nutritional values may differ from other countries. The user is 17 years old and an athlete, so factor in that they are physically active but also that Czech meal portions might be smaller or different than in other regions when estimating total_calories." +
                            "" +
                            "IF THIS '$mealDesc' IS DEFINITELY NOT MEAL, FORGOT EVERYTHING I JUST TOLD YOU AND JUST SAY 'ERROR'"
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
        try {
            val topLevelResponse = json.decodeFromString<TopLevelResponse>(rawJson)

            val contentJson = topLevelResponse.choices.first().message.content.trim('`', '\n')

            val mealCaloriesDesc = Json.decodeFromString<MealCaloriesDescGPT>(contentJson)

            return Result.success(
                mealCaloriesDesc
            )
        } catch (e: SerializationException) {
            println("Error")
            return Result.failure(Throwable("ERROR"))
        }

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

