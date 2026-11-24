class_name Pata
extends Node3D


signal animated_ground_pata_fired(is_right_side)

@export_category("Animation Settings")
@export var is_animated: bool = false # Solo para una pata y una ala

@export_category("Impulse Settings")
@export_enum("Q_key", "A_key", "Z_key", "E_key", "D_key",  "C_key",) 
var key_name: String
@export_enum("Q_key", "A_key", "Z_key", "E_key", "D_key",  "C_key",) 
var mirror_key_name: String

@export var impulse: float = 3.0
@export var needs_grounded: bool = false

var impulse_vector: Vector3
var groundchecks: Array[GroundCheck] = []

# --- Initialization ---

func _ready() -> void:
	var parent :Node3D = get_parent()
	_find_and_store_groundchecks(parent)

# --- Public Interface ---

func applyImpulse() -> bool:
	if needs_grounded and not _isPataGrounded():
		return false
		
	var final_impulse = _calculate_impulse_vector()
	get_parent().apply_impulse(final_impulse, global_position - get_parent().global_position)
	
	if is_animated:
		animated_ground_pata_fired.emit(true)
	
	return true

func applyMirrorImpulse() -> bool:
	if needs_grounded and not _isPataGrounded():
		return false
	
	var final_mirror_impulse = _calculate_mirror_impulse_vector()
	var mirrored_local_pos = position.bounce(Vector3.LEFT)
	var global_pos = get_parent().transform * mirrored_local_pos
	get_parent().apply_impulse(final_mirror_impulse, global_pos - get_parent().global_position)
	
	if is_animated:
		animated_ground_pata_fired.emit(false)
	
	return true


func getKey() -> String:
	return key_name

# --- Internal Rules & Math (Separation of Concerns) ---

func _calculate_impulse_vector() -> Vector3:
	var forward_dir: Vector3
	forward_dir = global_transform.basis.z
	
	return forward_dir * impulse

func _calculate_mirror_impulse_vector() -> Vector3:
	var mirrored_global_dir: Vector3
	mirrored_global_dir = get_parent().transform.basis * transform.basis.z.bounce(Vector3.LEFT)
	var global_dir = mirrored_global_dir.normalized()
	
	return global_dir * impulse

func _isPataGrounded():
	for groundchek in groundchecks:
		return groundchek.isGrounded()
	return true

func _find_and_store_groundchecks(node :Node3D) -> void:
	for child in node.get_children():
		if child is GroundCheck:
			groundchecks.append(child)
			_find_and_store_groundchecks(child)
	return
	
