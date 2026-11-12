extends Camera2D
const BASE_SPEED: float = 1000.0
const BOOST_MULTIPLIER: float = 2
const ZOOM_AMOUNT: float = 2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var horizontal: float = Input.get_axis("camera_left", "camera_right")
	var vertical: float = Input.get_axis("camera_up", "camera_down")
	var speed = BASE_SPEED
	
	if Input.is_action_pressed("zoom_in"):
		zoom += Vector2.ONE * ZOOM_AMOUNT * delta
	if Input.is_action_pressed("zoom_out"):
		zoom -= Vector2.ONE * ZOOM_AMOUNT * delta
	if Input.is_action_pressed("boost"):
		speed = speed * BOOST_MULTIPLIER
		
	position += Vector2(horizontal, vertical) * speed * delta
	position = position.clamp(Vector2(200, 170), Vector2(1700, 900))
	zoom = zoom.clampf(1, 6.5)

func _input(event: InputEvent) -> void:
	# scroll wheel is only detected by action released
	if event is InputEventMouseButton:
		if event.is_action_released("zoom_in"):
			zoom += ZOOM_AMOUNT * Vector2.ONE / 10
		elif event.is_action_released("zoom_out"):
			zoom -= ZOOM_AMOUNT * Vector2.ONE / 10
