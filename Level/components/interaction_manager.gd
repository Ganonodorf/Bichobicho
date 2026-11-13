class_name InteractionManager
extends Node

var _nearby: Array[Interactable] = []
var _focused: Interactable = null

signal interactable_focused(interactable: Interactable)
signal interactable_unfocused()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("interaction_manager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_update_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		_focused.interact()

func _update_focus() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null or _nearby.is_empty():
		_set_focus(null)
		return
	var closest: Interactable = null
	var closest_distance := INF
	for item in _nearby:
		var d := item.global_position.distance_to(player.global_position)
		if d < closest_distance:
			closest_distance = d
			closest = item
	_set_focus(closest)

func _set_focus(item: Interactable) -> void:
	if item == _focused:
		return
	if _focused != null:
		_focused.show_outline(false) # quitar outline anterior
	_focused = item
	if _focused != null:
		_focused.show_outline(true) # activar nueva outline
		if _focused.trigger_mode == Interactable.TriggerMode.INTERACT_KEY:
			interactable_focused.emit(_focused) # signal for UI to show "press E to interact"
	else:
		interactable_unfocused.emit() # signal for UI to hide

func add_interactable(item: Interactable) -> void:
	if not _nearby.has(item):
		_nearby.append(item)

func remove_interactable(item: Interactable) -> void:
	_nearby.erase(item)
	if _focused == item:
		_set_focus(null)
