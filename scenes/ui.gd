extends CanvasLayer

const STOP_TEXT = "STOP"
const START_TEXT = "START"

@onready var toggle_simulation_button = $FoldableContainer/GridContainer/ToggleSimulationButton

func _ready() -> void:
	toggle_simulation_button.text = START_TEXT

func  update_button(running: bool):
	toggle_simulation_button.text = STOP_TEXT if running else START_TEXT
