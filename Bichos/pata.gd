extends Node3D

@export var impulse: float = 3.0
@export var action: String = "action"

var on_ground: bool = false
var impulse_vector: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed(action)):
		impulse_vector = global_transform.basis.z * impulse
		get_parent().apply_impulse(impulse_vector, position)
	pass
