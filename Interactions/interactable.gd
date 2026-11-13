class_name Interactable
extends Node3D

enum TriggerMode { INTERACT_KEY, AUTO }

@export_group("Trigger")
@export var trigger_mode: TriggerMode = TriggerMode.INTERACT_KEY

@export_group("Dialog")
@export var dialog_timeline: String = ""

@export_group("Destination")
@export var destination_scene: String = ""
@export var destination_spawnpoint: String = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func interact() -> void:
	if dialog_timeline != "":
		get_tree().call_group("player", "set_dialog_active", true)
		Dialogic.start(dialog_timeline)
#		Dialogic.timeline_ended.connect(_on_dialog_ended, CONNECT_ONE_SHOT)
	elif destination_scene != "":
		Bichobicho.goto_scene(destination_scene, destination_spawnpoint)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	if trigger_mode == TriggerMode.AUTO:
		interact()
	else:
		var manager = get_tree().get_first_node_in_group("interaction_manager")
		if manager:
			manager.add_interactable(self)

func _on_dialog_ended() -> void:
	get_tree().call_group("player", "set_dialog_active", false)
	if destination_scene != "":
		Bichobicho.goto_scene(destination_scene, destination_spawnpoint)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	var manager = get_tree().get_first_node_in_group("interaction_manager")
	if manager:
		manager.remove_interactable(self)

func show_outline(_show: bool) -> void:
	return
