extends CharacterBody3D

@onready var phantom_camera_3d: PhantomCamera3D = $PhantomCamera3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var mouse_sensitivity_h = 0.25
@export var mouse_sensitivity_v = 0.15

var _dialog_active: bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity_h
		phantom_camera_3d.rotation_degrees.x -= event.relative.y * mouse_sensitivity_v
		phantom_camera_3d.rotation_degrees.x = clamp(phantom_camera_3d.rotation_degrees.x, -90, 90)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("bichero_left", "bichero_right", "bichero_up", "bichero_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


# --- Player interface (shared with all player types) ---
func set_dialog_active(active: bool) -> void:
	_dialog_active = active
func move_to_position(_pos: Vector3, _rot: Vector3):
	global_position = _pos
	global_rotation = _rot
