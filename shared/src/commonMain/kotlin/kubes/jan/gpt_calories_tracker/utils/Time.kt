package kubes.jan.gpt_calories_tracker.utils

import kotlinx.datetime.Instant
import kotlinx.datetime.TimeZone
import kotlinx.datetime.toLocalDateTime

fun timeToStringFormat(date: String): String {
    val datetimeDate = Instant.parse(date)
    val time = datetimeDate.toLocalDateTime(TimeZone.currentSystemDefault()).time

    val string = time.hour.toString() + ":"
    println(time.minute.toString())
    if (time.minute.toString().length < 2) {
        return string + "0" + time.minute.toString()
    } else {
        return string + time.minute.toString()
    }
}