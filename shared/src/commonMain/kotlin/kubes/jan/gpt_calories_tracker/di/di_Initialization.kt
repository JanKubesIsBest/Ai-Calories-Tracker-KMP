package kubes.jan.gpt_calories_tracker.di

import kubes.jan.gpt_calories_tracker.model.view_model.app_view_model.AppViewModel
import org.koin.core.context.startKoin
import org.koin.dsl.module


// Common App Definitions
fun appModule() = listOf(commonModule, platformModule)

val commonModule = module {
    single { AppViewModel() }
}