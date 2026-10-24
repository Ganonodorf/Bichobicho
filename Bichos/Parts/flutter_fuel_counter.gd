extends Node3D


@export var max_flutters = 10

var current_flutters: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_flutters = max_flutters
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _is_bug_grounded():
		_reset_flutters()
	pass

func are_there_flutters_left():
	if current_flutters > 0:
		current_flutters -= 1
		return true
	else:
		return false


# Helper function to check if the parent bug is touching the ground
func _is_bug_grounded() -> bool:
	var parent_bug = get_parent()
	
	# Look through the bug's children to see if any Pata is grounded
	for child in parent_bug.get_children():
		if child is Pata && child.groundcheck:
			if child.isPataGrounded():
				return true
	
	return false

func _reset_flutters():
	current_flutters = max_flutters
