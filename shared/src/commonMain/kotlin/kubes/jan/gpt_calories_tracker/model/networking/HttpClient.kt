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
import kubes.jan.gpt_calories_tracker.model.networking.UseCases.MealCaloriesDesc
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json

//curl -X POST "https://api.together.xyz/v1/chat/completions" \
//-H "Authorization: Bearer $TOGETHER_API_KEY" \
//-H "Content-Type: application/json" \
//-d '{
//"model": "meta-llama/Meta-Llama-3.1-405B-Instruct-Turbo",
//"messages": [],
//"max_tokens": null,
//"temperature": 0.7,
//"top_p": 0.7,
//"top_k": 50,
//"repetition_penalty": 1,
//"stop": ["<|eot_id|>","<|eom_id|>"],
//"stream": true
//}'

class MyHttpClient {
    private val client = HttpClient {
        install(ContentNegotiation) {
            json()
        }
    }

    suspend fun GetCalories(mealDesc: String): Result<MealCaloriesDesc> {
        val requestBody = MealRequestBody(
            model = "meta-llama/Meta-Llama-3.1-70B-Instruct-Turbo",
            messages = listOf(
                Message(
                    role = "system",
                    content = "This is a description of a meal I just ate: '$mealDesc' I want you to write a JSON file that contains 'heading', which is a max three word name of the meal, then 'description', this should contain how you imagine the meal and the 'calories', which is a Int which contains your prediction on how much calories the meal could have. Write ONLY the JSON file, nothing else. Start with { and end with } for proper json file."
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

        val mealCaloriesDesc = Json.decodeFromString<MealCaloriesDesc>(contentJson)

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

