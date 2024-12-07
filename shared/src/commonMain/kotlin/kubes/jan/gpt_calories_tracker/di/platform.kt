package kubes.jan.gpt_calories_tracker.di

import org.koin.core.module.dsl.singleOf
import org.koin.dsl.module

// platform Module
val platformModule = module {
    singleOf(::Platform)
}

// KMP Class Definition
expect class Platform() {
    val name: String
}