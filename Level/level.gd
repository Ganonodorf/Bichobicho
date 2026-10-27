class_name Level extends Node3D

var doors: Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	doors = get_tree().get_nodes_in_group("door")
	
	for door in doors:
		door.add_observer(self)

func notify(destiny_level: String, origin_level:String):
	Bichobicho.goto_scene(destiny_level, origin_level)
