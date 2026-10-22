class_name Level_trigger extends Area3D

@export var level_path: String

var levels: Array[Level]

func _on_body_entered(body: Node3D) -> void:
	if(body.is_in_group("Bichero")):
		for level in levels:
			level.notify(level_path)

func add_observer(level: Level):
	levels.append(level)
