package kubes.jan.gpt_calories_tracker

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform