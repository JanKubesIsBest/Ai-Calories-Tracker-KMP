package kubes.jan.gpt_calories_tracker.cache

import kubes.jan.gpt_calories_tracker.database.entity.MealCaloriesDesc
import kubes.jan.gpt_calories_tracker.database.entity.UserInfo


class Database(databaseDriverFactory: DriverFactory) {
    private val database = AppDatabase(databaseDriverFactory.createDriver())
    private val dbQuery = database.appDatabaseQueries

    internal fun getAllMeals(): List<MealCaloriesDesc> {
//        return createTestMeals()
        val allMeals = dbQuery.selectAllMeals(::mealSelecting).executeAsList()
        return allMeals;
    }

    internal fun editMealById(meal: MealCaloriesDesc) {
        dbQuery.updateMealById(meal.heading, meal.description, meal.date, meal.userDescription, meal.totalCalories.toLong(), meal.id.toLong())
    }

    internal fun getMealByDate(date: String): List<MealCaloriesDesc> {
        val meals = dbQuery.selectMealByDate(date, ::mealSelecting).executeAsList();

        return meals
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

    internal fun addUserData(userInfo: UserInfo) {
        var weight = 0
        if (userInfo.weight != null) {
            weight =  userInfo.weight.toInt()
        }

        dbQuery.insertUserInfo(userInfo.gender, weight.toLong(), userInfo.build, userInfo.country)
    }

    internal fun getUserInfo(): UserInfo {
        val info = dbQuery.selectUserInfo().executeAsOne()

        var weight = 0
        if (info.weight != null) {
            weight = info.weight.toInt()
        }

        return UserInfo(
            gender = info.gender,
            weight = weight,
            build = info.build,
            country = info.country
        )
    }
}



fun createTestMeals(): List<MealCaloriesDesc> {
    return listOf(
        MealCaloriesDesc(
            id = 1,
            heading = "Breakfast",
            description = "Eggs and toast",
            date = "2024-12-22T08:00:00Z", // 8:00 AM UTC
            userDescription = "Simple breakfast",
            totalCalories = 300
        ),
        MealCaloriesDesc(
            id = 2,
            heading = "Morning Snack",
            description = "Banana",
            date = "2024-12-22T08:15:00Z", // 8:15 AM UTC
            userDescription = "Quick snack",
            totalCalories = 100
        ),
        MealCaloriesDesc(
            id = 3,
            heading = "Lunch",
            description = "Chicken salad",
            date = "2024-12-22T08:45:00Z", // 8:45 AM UTC
            userDescription = "Healthy lunch",
            totalCalories = 400
        ),
        MealCaloriesDesc(
            id = 4,
            heading = "Afternoon Snack",
            description = "Yogurt",
            date = "2024-12-22T10:15:00Z", // 10:15 AM UTC
            userDescription = "Afternoon protein",
            totalCalories = 150
        ),
        MealCaloriesDesc(
            id = 5,
            heading = "Dinner",
            description = "Steak and potatoes",
            date = "2024-12-22T12:00:00Z", // 12:00 PM UTC
            userDescription = "Hearty dinner",
            totalCalories = 700
        ),
        MealCaloriesDesc(
            id = 6,
            heading = "Late Snack",
            description = "Protein bar",
            date = "2024-12-22T12:10:00Z", // 12:10 PM UTC
            userDescription = "Late-night snack",
            totalCalories = 200
        )
    )
}
