extends RigidBody3D

#@onready var cucaracha_phantom_camera_3d: PhantomCamera3D = $"../cucaracha PhantomCamera3D"


#@export var mouse_sensitivity: float = 0.05
#
#@export var min_pitch: float = -89.9
#@export var max_pitch: float = 50
#
#@export var min_yaw: float = 0
#@export var max_yaw: float = 360

@onready var impulse_point_left: Node3D = %"impulse point left"
@onready var impulse_point_right: Node3D = %"impulse point right"

@onready var roach_left_vector: Vector3
@onready var roach_right_vector: Vector3

@export var roach_impulse: float = 3.0
@export var roach_flight_impulse: float = 3.0

func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _physics_process(delta: float) -> void:
	roach_left_vector = impulse_point_left.global_transform.basis.z * roach_impulse
	roach_right_vector = impulse_point_right.global_transform.basis.z * roach_impulse
	if Input.is_action_just_pressed("roach_left"):
		apply_impulse(roach_left_vector, impulse_point_left.global_position - global_position)
	if Input.is_action_just_pressed("roach_right"):
		apply_impulse(roach_right_vector, impulse_point_right.global_position - global_position)


#func _unhandled_input(event: InputEvent) -> void:
	#_set_pcam_rotation(cucaracha_phantom_camera_3d, event)
#
#func _set_pcam_rotation(pcam: PhantomCamera3D, event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#var pcam_rotation_degrees: Vector3
#
		## Assigns the current 3D rotation of the SpringArm3D node - so it starts off where it is in the editor
		#pcam_rotation_degrees = pcam.get_third_person_rotation_degrees()
#
		## Change the X rotation
		#pcam_rotation_degrees.x -= event.relative.y * mouse_sensitivity
#
		## Clamp the rotation in the X axis so it go over or under the target
		#pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, min_pitch, max_pitch)
#
		## Change the Y rotation value
		#pcam_rotation_degrees.y -= event.relative.x * mouse_sensitivity
#
		## Sets the rotation to fully loop around its target, but witout going below or exceeding 0 and 360 degrees respectively
		#pcam_rotation_degrees.y = wrapf(pcam_rotation_degrees.y, min_yaw, max_yaw)
#
		## Change the SpringArm3D node's rotation and rotate around its target
		#pcam.set_third_person_rotation_degrees(pcam_rotation_degrees)
