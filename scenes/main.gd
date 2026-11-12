extends Node2D

var simulation_running: bool = false:
	get:
		return simulation_running
	set(value):
		simulation_running = value
		
		$UI.update_button(value)
		$Grid.toggle_simulation(value)
		
func _input(event: InputEvent) -> void:
	if event.is_action_released("toggle_simulation"):
		simulation_running = !simulation_running


func _on_toggle_simulation_button_pressed() -> void:
	simulation_running = !simulation_running
