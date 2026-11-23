class_name PataAla
extends Pata

signal animated_wing_pata_fired(is_right_side: bool)

@export var vertical_impulse: float = 0
@export var wing_impulse_always_horizontal: bool = false

var flutter_fuel_counter: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	_discover_and_cache_flutter_fuel_counter()

func applyImpulse() -> bool:
	if not _can_apply_impulse():
		return false
		
	var final_impulse = _calculate_impulse_vector()
	get_parent().apply_impulse(final_impulse, global_position - get_parent().global_position)
	
	if is_animated:
		var is_right_side = position.x < 0.0
		animated_wing_pata_fired.emit(is_right_side)
	
	return true

func _calculate_impulse_vector() -> Vector3:
	var forward_dir: Vector3
	
	if wing_impulse_always_horizontal:
		# Take the forward axis and flatten it onto the horizontal ground plane (y = 0)
		var raw_forward = global_transform.basis.z
		var flat_forward = Vector3(raw_forward.x, 0.0, raw_forward.z)
		
		if flat_forward.length_squared() > 0.001:
			forward_dir = flat_forward.normalized()
		else:
			forward_dir = Vector3.FORWARD
	else:
		# Use the standard local basis forward direction
		forward_dir = global_transform.basis.z
	
	return forward_dir * impulse + Vector3.UP * vertical_impulse

func _are_there_flutters_left() -> bool:
	if flutter_fuel_counter and flutter_fuel_counter.has_method("are_there_flutters_left"):
		return flutter_fuel_counter.are_there_flutters_left()
	return true # Fallback for infinite flight bugs

func _can_apply_impulse() -> bool:
	if needs_grounded:
		return _isPataGrounded() and _are_there_flutters_left()
	else:
		return _are_there_flutters_left()

func _discover_and_cache_flutter_fuel_counter() -> void:
	var parent_bug = get_parent()
	if not parent_bug:
		return
		
	for child in parent_bug.get_children():
		if child.has_method("are_there_flutters_left"):
			flutter_fuel_counter = child
			break
