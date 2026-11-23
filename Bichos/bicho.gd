extends RigidBody3D

class_name Bicho

@export_group("Camera")
@export var mouse_sensitivity: float = 0.05
@export var min_pitch: float = -40.0
@export var max_pitch: float = 20.0

var patas: Array[Pata]

var _dialog_frozen := false

@onready var phantom_camera: PhantomCamera3D = get_node_or_null("../PhantomCamera3D")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Pata:
			patas.append(child)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Bichobicho.game_state_changed.connect(_on_game_state_changed)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and phantom_camera:
		var rot = phantom_camera.get_third_person_rotation_degrees()
		rot.x -= event.relative.y * mouse_sensitivity
		rot.x = clampf(rot.x, min_pitch, max_pitch)
		rot.y -= event.relative.x * mouse_sensitivity
		rot.y = wrapf(rot.y, 0.0, 360.0)
		phantom_camera.set_third_person_rotation_degrees(rot)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	if(Input):
		for pata in patas:
			if Input.is_action_just_pressed(pata.key_name):
				pata.applyImpulse()
			if Input.is_action_just_pressed(pata.mirror_key_name):
				pata.applyMirrorImpulse()

	pass

func _physics_process(_delta: float) -> void:
	if _dialog_frozen:
		linear_velocity = Vector3.ZERO

# --- Player interface (shared with all player types) ---
func move_to_position(_pos: Vector3, _rot: Vector3):
	global_position = _pos
	global_rotation = _rot

func _on_game_state_changed(new_state :Bichobicho.GameState):
	if new_state == Bichobicho.GameState.DIALOG:
		_dialog_frozen = true
	else:
		_dialog_frozen = false
