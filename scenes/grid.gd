extends Control

const _BACKGROUND_COLOR: Color = Color("#20252B")
const _ALIVE_CELL_COLOR: Color =  Color.YELLOW
const _CELL_BORDER_COLOR: Color = Color("#343B44")

# The amount of cell inside the grid
const _GRID_SIZE: Vector2i = Vector2i(100, 100)
# How much of the screen the grid occups 
const _GRID_SCALE: float = 0.9
const _BORDER_WIDTH: float = -1

## The size of a individual tile
var _cell_size: Vector2
## Matrix containing the alive value of each cell with size `(_GRID_SIZE.y, _GRID_SIZE.x)`
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
var _cell_count = _GRID_SIZE.x * _GRID_SIZE.y

func _ready() -> void:
	print("number of cells: ", _cell_count)
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	size = get_viewport_rect().size
	_update_grid()

	_grid.resize(_GRID_SIZE.y)
	for y in range(_GRID_SIZE.y):
		_grid[y] = []
		_grid[y].resize(_GRID_SIZE.x)
		_grid[y].fill(false) # cells start dead

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_update_grid()


func _update_grid() -> void:
	var grid_dimensions := size * _GRID_SCALE
	_cell_size = grid_dimensions / Vector2(_GRID_SIZE)

	queue_redraw()


func _draw() -> void:
	print("Control size: ", size)
	var dimensions: Vector2 = Vector2(_GRID_SIZE) * _cell_size # the actual size of the grid
	var offset := (size - dimensions) / 2 # the empty space before the grid so it can be centered

	# draw background
	draw_rect(Rect2(offset, dimensions), _BACKGROUND_COLOR)
	
	# for each cell, paint white if alive
	for y in range(_GRID_SIZE.y):
		for x in range(_GRID_SIZE.x):
			# if alive
			if _grid[y][x]:
				var rect_position := offset + Vector2(x, y) * _cell_size
				draw_rect(Rect2(rect_position, _cell_size), _ALIVE_CELL_COLOR) # paint it

	# draw horizontal borders
	for y in range(_GRID_SIZE.y + 1):
		draw_line(Vector2(offset.x, (_cell_size.y * y) + offset.y), Vector2(size.x - offset.x, (_cell_size.y * y) + offset.y), _CELL_BORDER_COLOR, _BORDER_WIDTH)

	# draw vertical borders	
	for x in range(_GRID_SIZE.x + 1):
		draw_line(Vector2((_cell_size.x * x) + offset.x, offset.y), Vector2((_cell_size.x * x) + offset.x, size.y - offset.y), _CELL_BORDER_COLOR, _BORDER_WIDTH)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# calculate which cell it is based on the click position
			var offset := (size - Vector2(_GRID_SIZE) * _cell_size) / 2
			var cell := Vector2i((event.position - offset) / _cell_size)

			# only allow clicking inside the grid
			if cell.x >= 0 and cell.x < _GRID_SIZE.x and cell.y >= 0 and cell.y < _GRID_SIZE.y:
				_grid[cell.y][cell.x] = not _grid[cell.y][cell.x]
				queue_redraw()
