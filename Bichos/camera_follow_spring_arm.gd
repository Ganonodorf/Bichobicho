extends Camera3D

@export var spring_position: Node3D
@export var lerp_power: float = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = lerp(position, spring_position.position, delta * lerp_power)
