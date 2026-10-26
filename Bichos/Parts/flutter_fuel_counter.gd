extends Node3D


@export var max_flutters = 10
@export var infinite_flight: bool = false


var current_flutters: float
var walking_patas: Array[Node3D] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_flutters = max_flutters
	_discover_and_cache_walking_patas()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if _is_any_walking_pata_grounded():
		_reset_flutters_to_maximum()

func are_there_flutters_left() -> bool:
	if infinite_flight:
		return true
		
	if current_flutters > 0:
		current_flutters -= 1
		return true
	else:
		return false

# --- Dedicated Logic & Registration Functions ---

func _discover_and_cache_walking_patas() -> void:
	var parent_bug = get_parent()
	if not parent_bug:
		return
		
	for child in parent_bug.get_children():
		# Identify walking patas by checking if they possess a groundcheck reference
		if child.has_method("isPataGrounded") and "groundcheck" in child and child.groundcheck != null:
			walking_patas.append(child)

func _is_any_walking_pata_grounded() -> bool:
	for pata in walking_patas:
		if pata.isPataGrounded():
			return true
	return false

func _reset_flutters_to_maximum() -> void:
	current_flutters = max_flutters
