extends RayCast3D

@export_category("Suspension")
@export var spring_rest_lenth: float = 0.5
@export var spring_max_compression: float
@export var spring_stiffnes: float
@export var spring_stiffness_curve: Curve
@export var spring_damper: float

@export var lateral_friction: float = 0.5   # sideways grip, higher = more grip
@export var longitudinal_friction: float = 0.5  # forward/back rolling resistance

var last_frame_spring_length: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if is_colliding():
		var offset = global_position - get_parent().global_position
		var contact_velocity  = get_parent().linear_velocity + get_parent().angular_velocity.cross(offset)
		var local_friction_force = frictionForce(contact_velocity)
		var local_suspension_force = suspensionForce( global_transform.origin.distance_to(get_collision_point()) )
		get_parent().apply_force(local_suspension_force + local_friction_force, global_position - get_parent().global_position)

func suspensionForce(distanceToFloor: float):

	var spring_min_length = spring_rest_lenth - spring_max_compression
	
	var current_spring_length = clamp(distanceToFloor, spring_min_length, spring_rest_lenth)
	var spring_velocity = (last_frame_spring_length - current_spring_length)/ get_physics_process_delta_time()
	var spring_force = spring_stiffnes * spring_stiffness_curve.sample((spring_rest_lenth - current_spring_length) / spring_rest_lenth)
	var damper_force = spring_damper * spring_velocity
	
	last_frame_spring_length = current_spring_length
	
	return (spring_force + damper_force) * global_transform.basis.y



func frictionForce(contact_velocity: Vector3):
	var forward = global_transform.basis.z
	var sideways = global_transform.basis.x
	var lateral_velocity = contact_velocity.dot(sideways) 
	var longitudinal_velocity = contact_velocity.dot(forward)
	var friction_force = (-sideways * lateral_velocity * lateral_friction) + (-forward * longitudinal_velocity * longitudinal_friction)
	return friction_force
