class_name Interactable
extends Node3D

enum TriggerMode { INTERACT_KEY, AUTO }

@export_group("Trigger")
@export var trigger_mode: TriggerMode = TriggerMode.INTERACT_KEY
@export var mesh_node :MeshInstance3D = null

@export_group("Dialog")
@export var dialog_timeline: String = ""

@export_group("Destination")
@export var destination_scene: String = ""
@export var destination_spawnpoint: String = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# si no tiene mesh asignado busca uno entre sus hijos. 
	# solo para los INT- autoprocesados importados de blender.
	if mesh_node == null:
		for child in get_children():
			if child is MeshInstance3D:
				mesh_node = child
				break
	# esto substituye el material por una copia nueva para cada interactable
	if mesh_node != null:
		var original_mat = mesh_node.get_active_material(0)
		var override_mat: StandardMaterial3D
		if original_mat != null:
			override_mat = original_mat.duplicate()
		else:
			override_mat = StandardMaterial3D.new()
		mesh_node.set_surface_override_material(0, override_mat)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func interact() -> void:
	if dialog_timeline != "":
		Bichobicho.set_game_state(Bichobicho.GameState.DIALOG)
		Dialogic.start(dialog_timeline)
		Dialogic.timeline_ended.connect(_on_dialog_ended, CONNECT_ONE_SHOT)
	elif destination_scene != "":
		Bichobicho.goto_scene(destination_scene, destination_spawnpoint)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if not body.is_in_group("bichocoche"):
		return
	if trigger_mode == TriggerMode.AUTO:
		interact()
	else:
		var manager = get_tree().get_first_node_in_group("interaction_manager")
		if manager:
			manager.add_interactable(self)

func _on_dialog_ended() -> void:
	Bichobicho.set_game_state(Bichobicho.GameState.FREE)
	if destination_scene != "":
		Bichobicho.goto_scene(destination_scene, destination_spawnpoint)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if not body.is_in_group("bichocoche"):
		return
	var manager = get_tree().get_first_node_in_group("interaction_manager")
	if manager:
		manager.remove_interactable(self)

func show_outline(enable: bool) -> void:
	if mesh_node == null:
		return
	var mat = mesh_node.get_surface_override_material(0)
	if mat == null:
		return
	mat.emission_enabled = enable
	mat.emission = Color(0.985, 0.501, 0.0, 1.0)
	mat.emission_energy_multiplier = 0.2
