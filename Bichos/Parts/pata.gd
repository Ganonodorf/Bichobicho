extends Node3D

class_name Pata

@export_enum("Q_key", "A_key", "Z_key", "E_key", "D_key",  "C_key",) var key_name: String

@export var groundcheck: Node3D
@export var impulse: float = 3.0
@export var vertical_impulse: float = 0
@export var wing_impulse_always_horizontal: bool = false

var impulse_vector: Vector3
var flutter_fuel_counter: Node3D

# --- Initialization ---

func _ready() -> void:
	_discover_and_cache_flutter_fuel_counter()

# --- Public Interface ---

func applyImpulse() -> bool:
	if not _can_apply_impulse():
		return false
		
	var final_impulse = _calculate_impulse_vector()
	get_parent().apply_impulse(final_impulse, global_position - get_parent().global_position)
	return true

func getKey() -> String:
	return key_name

# --- Internal Rules & Math (Separation of Concerns) ---

func _can_apply_impulse() -> bool:
	if wing_impulse_always_horizontal:
		return _are_there_flutters_left()
	else:
		return isPataGrounded() and _are_there_flutters_left()

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

func isPataGrounded():
	if groundcheck:
		for child in groundcheck.get_children():
			if child is GroundCheck:
				return child.isGrounded()
	return true

func _are_there_flutters_left() -> bool:
	if flutter_fuel_counter and flutter_fuel_counter.has_method("are_there_flutters_left"):
		return flutter_fuel_counter.are_there_flutters_left()
	return true # Fallback for infinite flight bugs

func _discover_and_cache_flutter_fuel_counter() -> void:
	var parent_bug = get_parent()
	if not parent_bug:
		return
		
	for child in parent_bug.get_children():
		if child.has_method("are_there_flutters_left"):
			flutter_fuel_counter = child
			break
