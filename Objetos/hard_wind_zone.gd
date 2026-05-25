extends Area3D

@export var force: float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if(body.is_in_group('Bichos')):
		body.add_constant_central_force(force * global_transform.basis.z)
	pass # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	if(body.is_in_group('Bichos')):
		body.add_constant_central_force(-force * global_transform.basis.z)
	pass # Replace with function body.
