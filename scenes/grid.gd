extends Control

const _BACKGROUND_COLOR: Color = Color("#20252B")
const _ALIVE_CELL_COLOR: Color = Color.YELLOW
const _CELL_BORDER_COLOR: Color = Color("#343B44")

# The amount of cell inside the grid
const _BASE_GRID_SIZE: Vector2i = Vector2i(100, 50)
# How much of the screen the grid occups 
const _GRID_SCALE: float = 0.9
const _BORDER_WIDTH: float = -1

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

var _cell_count = _scaled_size.x * _scaled_size.y

var _size_multiplier: float = 0.2:
	get:
		return _size_multiplier
	set(value):
		_size_multiplier = value

		_scaled_size = value * _BASE_GRID_SIZE
		_cell_count = _scaled_size.x * _scaled_size.y

var _scaled_size: Vector2i = _size_multiplier * _BASE_GRID_SIZE

func _ready() -> void:
	print("number of cells: ", _cell_count)
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	size = get_viewport_rect().size
	_update_grid()

	_grid.resize(_scaled_size.y)
	for y in range(_scaled_size.y):
		_grid[y] = []
		_grid[y].resize(_scaled_size.x)
		_grid[y].fill(false) # cells start dead
	
	_next_grid = _grid.duplicate_deep()
	
	

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_update_grid()


func _update_grid() -> void:
	var avaible_space := size * _GRID_SCALE # the maximum amount of space the grid can occupy
	var cell_size: float = min(avaible_space.x / _scaled_size.x, avaible_space.y / _scaled_size.y) # calculate how large it can be in each axis and still fit all cells into the grid and then pick the lowest

	_cell_size = Vector2.ONE * cell_size # use its result as the cell size

	queue_redraw()


func _draw() -> void:
	print("Control size: ", size)
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

	# draw horizontal borders
	for y in range(_scaled_size.y + 1):
		draw_line(Vector2(offset.x, (_cell_size.y * y) + offset.y), Vector2(size.x - offset.x, (_cell_size.y * y) + offset.y), _CELL_BORDER_COLOR, _BORDER_WIDTH)

	# draw vertical borders	
	for x in range(_scaled_size.x + 1):
		draw_line(Vector2((_cell_size.x * x) + offset.x, offset.y), Vector2((_cell_size.x * x) + offset.x, size.y - offset.y), _CELL_BORDER_COLOR, _BORDER_WIDTH)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# calculate which cell it is based on the click position
			var offset := (size - Vector2(_scaled_size) * _cell_size) / 2
			var cell := Vector2i((event.position - offset) / _cell_size)

			# only allow clicking inside the grid
			if cell.x >= 0 and cell.x < _scaled_size.x and cell.y >= 0 and cell.y < _scaled_size.y:
				_grid[cell.y][cell.x] = not _grid[cell.y][cell.x]
				queue_redraw()

#Rules:
# Any live cell with fewer than two live neighbors dies.
# Any live cell with two or three neighbors lives on in the next generation.
# Any live cell with more than three live neighbors dies.
# Any dead cell with exactly three live neighbors becomes alive in the next generation.
# what is a neigbouhr?: given (x,y) everyone from (x-1, y-1) to (x+1, y+1) minus (x,y) - see neighbours.png
func _simulate() -> void:
	print(_grid)
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
	
	var temp: Array = []
	temp.append_array(_grid)
	
	_grid.clear()
	_grid.append_array(_next_grid)
	
	_next_grid.clear()
	_next_grid.append_array(temp)


	queue_redraw()

func _input(event: InputEvent) -> void:
	if event.is_action_released("toggle_simulation"):
		_simulate()

# what is a neigbouhr?: given (x,y) everyone from (x-1, y-1) to (x+1, y+1) minus (x,y) - see neighbours.png
func _get_alive_neighbors_count(x: int, y: int) -> int:
	# var neighbors: Array[bool]
	var alive_count: int = 0

	for i in range(x-1, x+2): # if it is out of bounds
		if i < 0 or i > (_grid.size() - 1):
			continue

		for j in range(y-1, y+2):
			if x == i and j == y: # if it is the cell we are at instead of a neighbour
				continue
			if j > (_grid[x].size() - 1) or j < 0: # if it is out of bounds
				continue

			# neighbors.append(_grid[i][j])
			if _grid[i][j] == true:
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
			return false
		elif alive_neighbors_count == 2 or alive_neighbors_count == 3:
			return true
		else:
			return false
	
	else:
		return alive_neighbors_count == 3
