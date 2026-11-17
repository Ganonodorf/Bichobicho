extends CharacterBody3D

@onready var phantom_camera_3d: PhantomCamera3D = $PhantomCamera3D
@onready var ui_manager: Node = $UIManager
@export var interact_detector_raycast: RayCast3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var mouse_sensitivity_h = 0.25
@export var mouse_sensitivity_v = 0.15

var _dialog_frozen := false
var manager: Node = null
var last_detected_interactable: Node3D = null

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Bichobicho.game_state_changed.connect(_on_game_state_changed)
	manager = get_tree().get_first_node_in_group("interaction_manager")
	if manager:
		manager.interactable_focused.connect(_on_interaction_manager_interactable_focused)
		manager.interactable_unfocused.connect(_on_interaction_manager_interactable_unfocused)

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity_h
		phantom_camera_3d.rotation_degrees.x -= event.relative.y * mouse_sensitivity_v
		phantom_camera_3d.rotation_degrees.x = clamp(phantom_camera_3d.rotation_degrees.x, -90, 90)

func _process(_delta: float) -> void:
	var detected_interactable = _detect_interactable()
	if detected_interactable != last_detected_interactable:
		manager.remove_interactable(last_detected_interactable)
		last_detected_interactable = null
	if detected_interactable != null:
		manager.add_interactable(detected_interactable)
		last_detected_interactable = detected_interactable

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

func _detect_interactable() -> Node3D:
	if interact_detector_raycast.is_colliding():
		var collider_object = interact_detector_raycast.get_collider()
		if collider_object.is_in_group("interactable"):
			return collider_object
		if collider_object.get_parent().is_in_group("interactable"):
			return collider_object.get_parent()
		if collider_object.get_parent().get_parent().is_in_group("interactable"):
			return collider_object.get_parent().get_parent()
	return null

# --- Player interface (shared with all player types) ---
func move_to_position(_pos: Vector3, _rot: Vector3):
	global_position = _pos
	global_rotation = _rot

func _on_game_state_changed(new_state :Bichobicho.GameState) -> void:
	if new_state == Bichobicho.GameState.DIALOG:
		_dialog_frozen = true
	else:
		_dialog_frozen = false

func _on_interaction_manager_interactable_focused(_interactable: Interactable) -> void:
	ui_manager.set_interact_flag(true)

func _on_interaction_manager_interactable_unfocused() -> void:
	ui_manager.set_interact_flag(false)
