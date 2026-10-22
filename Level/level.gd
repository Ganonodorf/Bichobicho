class_name Level extends Node3D

@export var level_triggers: Array[Level_trigger]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for level_trigger in level_triggers:
		level_trigger.add_observer(self)

func notify(path: String):
	Bichobicho.goto_scene(path)
