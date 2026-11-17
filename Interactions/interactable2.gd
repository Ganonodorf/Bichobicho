class_name Interactable2
extends Node3D

@export_group("Dialog")
@export var dialog_timeline: String = ""

@export_group("Destination")
@export var destination_scene: String = ""
@export var destination_spawnpoint: String = ""

var manager: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_area3d_signals()
	manager = get_tree().get_first_node_in_group("interaction_manager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func interact() -> void:
	if dialog_timeline != "":
		Bichobicho.set_game_state(Bichobicho.GameState.DIALOG)
		Dialogic.start(dialog_timeline)
	elif destination_scene != "":
		Bichobicho.goto_scene(destination_scene, destination_spawnpoint)

func _connect_area3d_signals() -> void:
	var area3d = _find_area3d_in_children(self)
	if area3d:
		area3d.body_entered.connect(_on_area_3d_body_entered)
		area3d.body_exited.connect(_on_area_3d_body_exited)

func _find_area3d_in_children(node: Node3D) -> Area3D:
	for child in node.get_children():
		var result = _find_area3d_in_children(child)
		if result:
			return result
	if node is Area3D:
		return node
	return null

func _on_area_3d_body_entered(_body: Node3D) -> void:
	pass

func _on_area_3d_body_exited(_body: Node3D) -> void:
	pass
