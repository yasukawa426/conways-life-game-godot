extends Node2D

const _GRID_SIZE: Vector2i = Vector2i(100, 100)

var viewport_size: Vector2:
	get:
		return viewport_size
	set(value):
		viewport_size = value

		_tile_size = Vector2(value.x / _GRID_SIZE.x, value.y / _GRID_SIZE.y)
		_tile_amount = _GRID_SIZE.x * _GRID_SIZE.y


var _tile_size: Vector2
var _tile_amount: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport_size = get_viewport_rect().size
	_generate_grid()

func _process(delta: float) -> void:
	if Input.is_physical_key_pressed(KEY_R):
		_generate_grid()

func _generate_grid() -> void:
	$Control/Grid.columns = _GRID_SIZE.y
	$Control/Grid.add_theme_constant_override("h_separation", 0)
	$Control/Grid.add_theme_constant_override("v_separation", 0)

	for node in $Control/Grid.get_children():
		node.queue_free()
	
	for i in range(_tile_amount):
		var color_rect: ColorRect = ColorRect.new()
		color_rect.color = Color(randf(), randf(), randf(), 1.0)
		color_rect.custom_minimum_size = _tile_size
		color_rect.gui_input.connect(_clicked.bind(color_rect))

		$Control/Grid.add_child(color_rect)
	
	await get_tree().process_frame
	print("Viewport: ", viewport_size)
	print("Grid: ", $Control/Grid.size)
	print("Tile: ", _tile_size)
	print("Grid minimum: ", $Control/Grid.get_combined_minimum_size())
	var last_tile = $Control/Grid.get_child(_tile_amount - 1)
	print("Last tile position: ", last_tile.position)
	print("Last tile size: ", last_tile.size)
	print("Grid end: ", last_tile.position + last_tile.size)

func _clicked(event: InputEvent, affected_node: ColorRect):
	if event is InputEventMouseButton and event.is_pressed():
		affected_node.self_modulate.a = 0 if affected_node.self_modulate.a == 1 else 1
