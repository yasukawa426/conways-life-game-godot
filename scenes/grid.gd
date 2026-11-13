extends Control
signal population_changed(value: int)
signal generation_changed(value: int)

const _BACKGROUND_COLOR: Color = Color("#20252B")
const _ALIVE_CELL_COLOR: Color = Color.GREEN
const _CELL_BORDER_COLOR: Color = Color("#343B44")

# The amount of cell inside the grid
const _BASE_GRID_SIZE: Vector2i = Vector2i(100, 50)
# How much of the screen the grid occups 
const _GRID_SCALE: float = 0.9
const _BORDER_WIDTH: float = -1

@onready var simulation_timer: Timer = $SimulationTimer
## The size of a individual tile
var _cell_size: Vector2
## Matrix containing the alive value of each cell with size `(_BASE_GRID_SIZE.y, _BASE_GRID_SIZE.x)`
##
##e.g: for a (2, 3) grid_size:
## [code]
## [
##	[true, false], 
##	[true, false],
##	[true, false]
##]
##[/code]
var _grid: Array[Array] = []
var _next_grid: Array[Array] = []

var _population: int = 0:
	set(value):
		_population = value
		population_changed.emit(value)
var _generation: int = 0:
		set(value):
			_generation = value
			generation_changed.emit(value)

const _BASE_SIMULATION_WAIT_TIME: float = 0.1
var _simulation_wait_time: float = _BASE_SIMULATION_WAIT_TIME
var speed_multiplier: float = 1:
	set(value):
		speed_multiplier = value
		
		_simulation_wait_time = _BASE_SIMULATION_WAIT_TIME / value
		simulation_timer.wait_time = _simulation_wait_time
		
		if _simulation_running:
			simulation_timer.start()

var _simulation_running: bool = false

#TODO: make timer oneshot and then call it again after the simulation() has finished running, buttons and stuff. hold left mouse button. draw border once in a separete node ultil needed again. also LMB only to dray RMB only to delete
var size_multiplier: float = 0.5:
	get:
		return size_multiplier
	set(value):
		size_multiplier = value
		
		_update_grid()

var _scaled_size: Vector2i = size_multiplier * _BASE_GRID_SIZE

func _ready() -> void:
	simulation_timer.wait_time = _simulation_wait_time
	print("grid size:", _scaled_size)
	simulation_timer.paused = true
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	size = get_viewport_rect().size
	_update_grid()

func _process(_delta: float) -> void:
	var mouse_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
	if mouse_pressed:
		var mouse_position: Vector2 = get_local_mouse_position()
		var is_left: bool = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
		# calculate which cell it is based on the click position
		var offset := (size - Vector2(_scaled_size) * _cell_size) / 2
		var cell := Vector2i((mouse_position - offset) / _cell_size)

		# only allow clicking inside the grid
		if cell.x >= 0 and cell.x < _scaled_size.x and cell.y >= 0 and cell.y < _scaled_size.y:
			var current = _grid[cell.y][cell.x]

			if current == false and is_left:
				_population += 1
			
			elif current == true and is_left == false:
				_population -= 1

			_grid[cell.y][cell.x] = is_left # left - alive; right - dead
			queue_redraw()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_update_grid()


func _update_grid() -> void:
	_scaled_size = size_multiplier * _BASE_GRID_SIZE
	_reset_arrays()

	var avaible_space := size * _GRID_SCALE # the maximum amount of space the grid can occupy
	var cell_size: float = min(avaible_space.x / _scaled_size.x, avaible_space.y / _scaled_size.y) # calculate how large it can be in each axis and still fit all cells into the grid and then pick the lowest
	
	
	_cell_size = Vector2.ONE * cell_size # use its result as the cell size
	
	print("New size: ", _scaled_size, _cell_size)
	queue_redraw()


func _draw() -> void:
	var dimensions: Vector2 = Vector2(_scaled_size) * _cell_size # the actual size of the grid
	var offset := (size - dimensions) / 2 # the empty space before the grid so it can be centered

	# draw background
	draw_rect(Rect2(offset, dimensions), _BACKGROUND_COLOR)
	
	# for each cell, paint white if alive
	for y in range(_scaled_size.y):
		for x in range(_scaled_size.x):
			# if alive
			if _grid[y][x]:
				var rect_position := offset + Vector2(x, y) * _cell_size
				draw_rect(Rect2(rect_position, _cell_size), _ALIVE_CELL_COLOR) # paint it
	
	$BordersVisual.draw_borders(offset, _scaled_size, _cell_size)

	
#Rules:
# Any live cell with fewer than two live neighbors dies.
# Any live cell with two or three neighbors lives on in the next generation.
# Any live cell with more than three live neighbors dies.
# Any dead cell with exactly three live neighbors becomes alive in the next generation.
# what is a neigbouhr?: given (x,y) everyone from (x-1, y-1) to (x+1, y+1) minus (x,y) - see neighbours.png
func _simulate() -> void:
	var x = 0
	var y = 0
	for row in _grid:
		for cell in row:
			# var neighbors: Array[bool] = _get_alive_neighbors_count(x, y)
			var alive: int = _get_alive_neighbors_count(x, y)
			_next_grid[x][y] = _apply_rules(cell, alive)
			
			y += 1
		y = 0
		x += 1
	
	var temp = _grid
	_grid = _next_grid
	_next_grid = temp

	queue_redraw()

# what is a neigbouhr?: given (x,y) everyone from (x-1, y-1) to (x+1, y+1) minus (x,y) - see neighbours.png
func _get_alive_neighbors_count(x: int, y: int) -> int:
	# var neighbors: Array[bool]
	var alive_count: int = 0

	for i in range(x - 1, x + 2): # if it is out of bounds
		if i < 0 or i > (_grid.size() - 1):
			continue

		var row = _grid[i]
		for j in range(y - 1, y + 2):
			if x == i and j == y: # if it is the cell we are at instead of a neighbour
				continue
			if j > (row.size() - 1) or j < 0: # if it is out of bounds
				continue

			# neighbors.append(_grid[i][j])
			if row[j] == true:
				alive_count += 1


	return alive_count

#Rules:
# Any live cell with fewer than two live neighbors dies.
# Any live cell with two or three neighbors lives on in the next generation.
# Any live cell with more than three live neighbors dies.
# Any dead cell with exactly three live neighbors becomes alive in the next generation.
func _apply_rules(is_alive: bool, alive_neighbors_count: int) -> bool:
	if is_alive:
		if alive_neighbors_count < 2:
			_population -= 1
			return false
		elif alive_neighbors_count == 2 or alive_neighbors_count == 3:
			return true
		else:
			_population -= 1
			return false
	
	else:
		if alive_neighbors_count == 3:
			_population += 1
			return true
		return false
	
func toggle_simulation(running: bool):
	_simulation_running = running
	simulation_timer.paused = !running
	simulation_timer.start()
	

func _on_simulation_timer_timeout() -> void:
	_simulate()
	queue_redraw()

	_generation += 1
	simulation_timer.start()

func _reset_arrays() -> void:
	if _population > 0 or _generation > 0:
		_population = 0
		_generation = 0
		
	_grid.resize(_scaled_size.y)
	for y in range(_scaled_size.y):
		_grid[y] = []
		_grid[y].resize(_scaled_size.x)
		_grid[y].fill(false) # cells start dead
	
	_next_grid = _grid.duplicate_deep()

func reset_grid():
	_reset_arrays()
	queue_redraw()
