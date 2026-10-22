extends Node3D

var current_scene = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_scene = get_tree().root.get_child(-1)

func goto_scene(path: String):
	_deferred_goto_scene.call_deferred(path)

func _deferred_goto_scene(path: String):
	current_scene.free()
	
	var resourceLoader = ResourceLoader.load(path)
	
	current_scene = resourceLoader.instantiate()
	
	get_tree().root.add_child(current_scene)
