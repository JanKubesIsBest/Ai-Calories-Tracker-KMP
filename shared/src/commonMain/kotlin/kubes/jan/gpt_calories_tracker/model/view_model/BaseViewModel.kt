package kubes.jan.gpt_calories_tracker.model.view_model

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.SharedFlow

open class BaseViewModel : ViewModel() {}

// Define a sealed class for events
open class UiEvent {}