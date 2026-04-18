extends Node3D

class_name Pata

@export var impulse: float = 3.0

@export_enum("Q_key", "A_key", "E_key", "D_key") var key_name: String

var on_ground: bool = false
var impulse_vector: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func applyImpulse():
	if isPataGrounded():
		impulse_vector = global_transform.basis.z * impulse
		get_parent().apply_impulse(impulse_vector, global_position - get_parent().global_position)
	pass

func isPataGrounded():
	for child in get_children():
		if child is GroundCheck:
			return child.isGrounded()

func getKey():
	return key_name
