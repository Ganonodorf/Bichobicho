extends MeshInstance3D

func _ready() -> void:
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# If the game IS running, hide this node entirely
	if Engine.is_editor_hint() == false:
		visible = false
	else:
		# If we are just sitting in the editor, make sure it's visible
		visible = true
