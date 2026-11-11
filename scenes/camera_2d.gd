extends Camera2D
const SPEED: float = 500.0
const ZOOM_AMOUNT: float = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var horizontal: float = Input.get_axis("camera_left", "camera_right")
	var vertical: float = Input.get_axis("camera_up", "camera_down")
	
	position += Vector2(horizontal, vertical) * SPEED * delta
	
	if Input.is_action_pressed("zoom_in"):
		zoom += Vector2.ONE * ZOOM_AMOUNT * delta
	if Input.is_action_pressed("zoom_out"):
		zoom -= Vector2.ONE * ZOOM_AMOUNT * delta
	
	zoom = zoom.clampf(1, 400)
