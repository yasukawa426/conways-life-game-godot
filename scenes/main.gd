extends Node2D
const MINIMUM_GRID_MULTIPLIER: float = 0.2
const MAXIMUM_GRID_MULTIPLIER: float = 5

var size_multiplier_step: float = (MAXIMUM_GRID_MULTIPLIER - MINIMUM_GRID_MULTIPLIER) / 50; # ~50 positions on the slider
var current_grid_multiplier: float = 0.5:
	get:
		return current_grid_multiplier
	
	set(value):
		current_grid_multiplier = value
		$Grid.size_multiplier = value
		
		simulation_running = false


var simulation_running: bool = false:
	get:
		return simulation_running
	set(value):
		simulation_running = value
		
		ui_node.update_toggle_button(value)
		$Grid.toggle_simulation(value)

const MINIMUM_SPEED_MULTIPLIER: float = 0.25
const MAXIMUM_SPEED_MULTIPLIER: float = 2

var speed_multiplier_step: float = (MAXIMUM_SPEED_MULTIPLIER - MINIMUM_SPEED_MULTIPLIER) / 50; # ~50 positions on the slider
var current_speed_multiplier: float = 1:
	get:
		return current_speed_multiplier
	
	set(value):
		current_speed_multiplier = value
		$Grid.speed_multiplier = value
		
@onready var ui_node = $UI

func _ready() -> void:
	_set_size_slider()
	_set_speed_slider()

func _input(event: InputEvent) -> void:
	if event.is_action_released("toggle_simulation"):
		simulation_running = !simulation_running
	
	if event.is_action_released("reset"):
		_reset()

func _set_speed_slider() -> void:
	ui_node.set_up_speed_slider(MINIMUM_SPEED_MULTIPLIER, MAXIMUM_SPEED_MULTIPLIER, speed_multiplier_step, current_speed_multiplier)

func _set_size_slider() -> void:
	ui_node.set_up_size_slider(MINIMUM_GRID_MULTIPLIER, MAXIMUM_GRID_MULTIPLIER, size_multiplier_step, current_grid_multiplier)


func _on_ui_toggle_simulation() -> void:
	simulation_running = !simulation_running


func _on_ui_size_changed(value: float) -> void:
	current_grid_multiplier = value


func _on_ui_speed_changed(value: float) -> void:
	current_speed_multiplier = value


func _on_ui_reset() -> void:
	_reset()

func _reset() -> void:
	simulation_running = false
	$Grid.reset_grid()


func _on_ui_exit() -> void:
	get_tree().quit(0)


func _on_grid_generation_changed(value: int) -> void:
	ui_node.set_generation(value)


func _on_grid_population_changed(value: int) -> void:
	ui_node.set_population(value)
