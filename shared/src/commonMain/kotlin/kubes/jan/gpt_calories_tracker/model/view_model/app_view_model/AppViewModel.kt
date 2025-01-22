package kubes.jan.gpt_calories_tracker.model.view_model.app_view_model

import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.asSharedFlow

sealed class Event {
    data class DeleteEvent(val id: Int) : Event()
    data object UpdateMeals : Event()
}

// This model with be injected with Coin
// Models listen for global events coming from this view model
class AppViewModel {
    private val _events = MutableSharedFlow<Event>()
    val events = _events.asSharedFlow()

    suspend fun postEvent(event: Event) {
        _events.emit(event)
    }
}