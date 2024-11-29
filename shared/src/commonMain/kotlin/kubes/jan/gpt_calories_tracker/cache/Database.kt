package kubes.jan.gpt_calories_tracker.cache

import kubes.jan.gpt_calories_tracker.database.entity.MealCaloriesDesc


class Database(databaseDriverFactory: DriverFactory) {
    private val database = AppDatabase(databaseDriverFactory.createDriver())
    private val dbQuery = database.appDatabaseQueries

    internal fun getAllMeals(): List<MealCaloriesDesc> {
        return dbQuery.selectAllMeals(::mealSelecting).executeAsList()
    }

    private fun mealSelecting(
        id: Long,
        heading: String,
        description: String,
        date: String,
        userDescription: String,
        totalCalories: Long,
    ) : MealCaloriesDesc {
        return MealCaloriesDesc(
            heading = heading,
            description = description,
            date = date,
            userDescription = userDescription,
            totalCalories = totalCalories.toInt(),
            id = id.toInt()
        )
    }

    internal fun insertMeal(mealCaloriesDesc: MealCaloriesDesc) {
        dbQuery.insertMeal(heading = mealCaloriesDesc.heading, description = mealCaloriesDesc.description, date = mealCaloriesDesc.date, user_description = mealCaloriesDesc.userDescription, total_calories = mealCaloriesDesc.totalCalories.toLong())
    }

    internal fun lastInsertedRowId(): Int {
        return dbQuery.lastInsertRowId().executeAsOne().toInt()
    }

    internal fun deleteMealById(id: Int) {
        return dbQuery.deleteMealById(id.toLong())
    }
}
