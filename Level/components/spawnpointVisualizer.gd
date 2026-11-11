extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint() and self.is_inside_tree():
		queue_free()
