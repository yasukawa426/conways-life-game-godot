extends Control

const _CELL_BORDER_COLOR: Color = Color("#343B44")
const _BORDER_WIDTH: float = -1

var _grid_size: Vector2
var _offset: Vector2
var _cell_size: Vector2
var _initialized: bool = false

func _draw() -> void:
	if not _initialized:
		return
		
	var lines: PackedVector2Array = []
	# draw horizontal borders
	for y in range(_grid_size.y + 1):
		lines.append(Vector2(_offset.x, (_cell_size.y * y) + _offset.y))
		lines.append(Vector2(size.x - _offset.x, (_cell_size.y * y) + _offset.y))

	# draw vertical borders
	for x in range(_grid_size.x + 1):
		lines.append(Vector2((_cell_size.x * x) + _offset.x, _offset.y))
		lines.append(Vector2((_cell_size.x * x) + _offset.x, size.y - _offset.y))

	draw_multiline(lines, _CELL_BORDER_COLOR, _BORDER_WIDTH)

func draw_borders(offset: Vector2, scalled_grid_size: Vector2, cell_size: Vector2) -> void:
	_offset = offset
	_grid_size = scalled_grid_size
	_cell_size = cell_size
	
	_initialized = true
	queue_redraw()
