extends RigidBody3D

class_name Bicho

var patas: Array[Pata]

var _dialog_frozen := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Pata:
			patas.append(child)
	Bichobicho.game_state_changed.connect(_on_game_state_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	if(Input):
		for pata in patas:
			if Input.is_action_just_pressed(pata.key_name):
				pata.applyImpulse()

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
