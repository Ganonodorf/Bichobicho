extends RigidBody3D

class_name Bicho

var patas: Array[Pata]

var _dialog_active: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Pata:
			patas.append(child)
			
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	if(Input):
		for pata in patas:
			if Input.is_action_just_pressed(pata.key_name):
				pata.applyImpulse()

	pass

# --- Player interface (shared with all player types) ---
func set_dialog_active(active: bool) -> void:
	_dialog_active = active
func move_to_position(_pos: Vector3, _rot: Vector3):
	global_position = _pos
	global_rotation = _rot
