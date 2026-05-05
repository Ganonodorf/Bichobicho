extends RayCast3D

class_name GroundCheck

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func isGrounded():
	if is_colliding():
		return true
	
	for child in get_children():
		if child is GroundCheck:
			return child.isGrounded()
