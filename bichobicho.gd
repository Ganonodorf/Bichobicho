extends Node3D

var current_scene = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_scene = get_tree().root.get_child(-1)

func goto_scene(destiny_level: String, origin_level: String):
	_deferred_goto_scene.call_deferred(destiny_level, origin_level)

func _deferred_goto_scene(destiny_level: String, origin_level: String):
	current_scene.free()
	
	var resourceLoader = ResourceLoader.load(destiny_level)
	
	current_scene = resourceLoader.instantiate()
	
	get_tree().root.add_child(current_scene)
	
	var door = _search_door(destiny_level, origin_level)
	print(destiny_level)
	print(origin_level)
	if(door != null):
		get_tree().call_group("bichero", "move_to_position", door.get_destination_position())

func _search_door(destiny_level: String, origin_level: String) -> Door:
	var doors = get_tree().get_nodes_in_group("door")
	for door in doors:
		print(door)
		print(door.is_your_other_side(destiny_level, origin_level))
		if(door.is_your_other_side(destiny_level, origin_level)):
			return door
	
	return null
