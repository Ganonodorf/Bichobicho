extends RigidBody3D

class_name Bicho

var patas: Array[Pata]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Pata:
			patas.append(child)
			
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input):
		for pata in patas:
			if Input.is_action_just_pressed(pata.key_name):
				pata.applyImpulse()
	pass
