package kubes.jan.gpt_calories_tracker.cache

import app.cash.sqldelight.db.SqlDriver

expect class DriverFactory {
    fun createDriver(): SqlDriver
}