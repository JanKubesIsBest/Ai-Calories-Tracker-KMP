package kubes.jan.gpt_calories_tracker.cache

import kubes.jan.gpt_calories_tracker.database.entity.MealCaloriesDesc


class Database(databaseDriverFactory: DriverFactory) {
    private val database = AppDatabase(databaseDriverFactory.createDriver())
    private val dbQuery = database.appDatabaseQueries

    internal fun getAllMeals(): List<MealCaloriesDesc> {
        val allMeals = dbQuery.selectAllMeals(::mealSelecting).executeAsList()
        println(allMeals)
        return allMeals;
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

    internal fun insertMeal(mealCaloriesDesc: MealCaloriesDesc): Int {
        return dbQuery.transactionWithResult {
            dbQuery.insertMeal(heading = mealCaloriesDesc.heading, description = mealCaloriesDesc.description, date = mealCaloriesDesc.date, user_description = mealCaloriesDesc.userDescription, total_calories = mealCaloriesDesc.totalCalories.toLong())
            dbQuery.lastInsertRowId().executeAsOne().toInt()
        }
    }

    internal fun deleteMealById(id: Int) {
        println(dbQuery.deleteMealById(id.toLong()))
    }
}
