extends RayCast3D

@export_category("Suspension")
@onready var spring_rest_lenth: float
@export var spring_max_compression: float
@export var spring_stiffnes: float
@export var spring_stiffness_curve: Curve
@export var spring_damper: float

var last_frame_spring_length: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_colliding():
		var local_suspension_force = -global_transform.basis.z * suspensionForce( global_transform.origin.distance_to(get_collision_point()) )
		get_parent().apply_force(local_suspension_force, global_position - get_parent().global_position)

func suspensionForce(distanceToFloor: float):

	var spring_min_length = spring_rest_lenth - spring_max_compression
	
	var current_spring_length = clamp(distanceToFloor, spring_min_length, spring_rest_lenth)
	var spring_velocity = (last_frame_spring_length - current_spring_length)/ get_physics_process_delta_time()
	var spring_force = spring_stiffnes * spring_stiffness_curve.sample((spring_rest_lenth - current_spring_length) / spring_rest_lenth)
	var damper_force = spring_damper * spring_velocity
	
	last_frame_spring_length = current_spring_length
	
	return (spring_force + damper_force) * Vector3.UP

func suspension(suspension_ray: RayCast3D):
	if suspension_ray.is_colliding():
		var contact := suspension_ray.get_collision_point()
		var spring_up_dir := suspension_ray.global_transform.basis.y
		var spring_length := suspension_ray.global_position.distance_to(contact)
		var offset := spring_rest_lenth - spring_length
		
		var spring_force := spring_stiffnes * offset
		var force_vector := spring_force * spring_up_dir
		
