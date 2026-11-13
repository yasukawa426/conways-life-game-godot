extends CanvasLayer
signal size_changed(value: float)
signal speed_changed(value: float)
signal next_generation
signal toggle_simulation
signal toggle_borders
signal reset
signal exit

const STOP_TEXT = "STOP"
const START_TEXT = "START"
const DEBOUNCE_TIMER_WAIT_TIME: float = 0.05

@onready var toggle_simulation_button: Button = $PanelContainer/FoldableContainer/GridContainer/ToggleSimulationButton
@onready var speed_slider: HSlider = $PanelContainer/FoldableContainer/GridContainer/BoxContainer2/SpeedHSlider
@onready var speed_timer: Timer = speed_slider.get_child(0) # SpeedTimer
@onready var size_slider: HSlider = $PanelContainer/FoldableContainer/GridContainer/BoxContainer/SizeHSlider
@onready var size_timer: Timer = size_slider.get_child(0) # /SizeTimer
@onready var population_label: Label = $PanelContainer/FoldableContainer/GridContainer/PopulationLabel
@onready var generation_label: Label = $PanelContainer/FoldableContainer/GridContainer/GenerationLabel

func _ready() -> void:
	$PanelContainer/FoldableContainer/GridContainer/BoxContainer2/SpeedLabel.custom_minimum_size = $PanelContainer/FoldableContainer/GridContainer/BoxContainer/SizeLabel.custom_minimum_size
	toggle_simulation_button.text = START_TEXT
	size_timer.wait_time = DEBOUNCE_TIMER_WAIT_TIME
	speed_timer.wait_time = DEBOUNCE_TIMER_WAIT_TIME

func update_toggle_button(running: bool):
	toggle_simulation_button.text = STOP_TEXT if running else START_TEXT

func set_up_speed_slider(minimum_value: float, maximum_value: float, step: float, initial_value: float) -> void:
	speed_slider.min_value = minimum_value
	speed_slider.max_value = maximum_value
	speed_slider.step = step
	speed_slider.value = initial_value

func set_up_size_slider(minimum_value: float, maximum_value: float, step: float, initial_value: float) -> void:
	size_slider.min_value = minimum_value
	size_slider.max_value = maximum_value
	size_slider.step = step
	size_slider.value = initial_value


func _on_size_timer_timeout() -> void:
	size_changed.emit(size_slider.value)

func _on_speed_timer_timeout() -> void:
	speed_changed.emit(speed_slider.value)

func _on_size_h_slider_value_changed(_value: float) -> void:
	size_timer.start()

func _on_speed_h_slider_value_changed(_value: float) -> void:
	speed_timer.start()


func _on_toggle_simulation_button_pressed() -> void:
	toggle_simulation.emit()


func _on_reset_button_pressed() -> void:
	reset.emit()


func _on_exit_button_pressed() -> void:
	exit.emit()
	
func set_generation(value: int) -> void:
	if generation_label:
		generation_label.text = "Generation: " + str(value)

func set_population(value: int) -> void:
	if population_label:
		population_label.text = "Population: " + str(value)


func _on_toggle_borders_button_pressed() -> void:
	toggle_borders.emit()


func _on_next_button_pressed() -> void:
	next_generation.emit()
