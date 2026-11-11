class_name SpawnPoint
extends Node3D

@export var spawnpoint_id: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if spawnpoint_id != "":
		Bichobicho.register_spawnpoint(spawnpoint_id, self)

func _exit_tree() -> void:
	Bichobicho.unregiste_spawnpoint(spawnpoint_id)
