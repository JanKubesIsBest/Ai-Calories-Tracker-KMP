package kubes.jan.gpt_calories_tracker.di

import org.koin.core.context.startKoin

fun initKoin(){
    startKoin {
        modules(
            appModule()
        )
    }
}