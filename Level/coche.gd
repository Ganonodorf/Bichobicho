extends RigidBody3D

@export var spring_strength: float = 100.0
@export var spring_damping: float = 2.0
@export var suspension_rest_distance: float = 0.5
@export var wheel_radius = 0.45

var wheels: Array[RayCast3D]

func _ready() -> void:
	wheels.append($WheelFrontLeft)
	wheels.append($WheelFrontRight)
	wheels.append($WheelRearLeft)
	wheels.append($WheelRearRight)

func _physics_process(delta: float) -> void:
	for raycast: RayCast3D in wheels:
		_calculate_suspension(raycast)
		#_calculate_steering(raycast)
		#_calculate_acceleration(raycast)

func _get_point_velocity(point: Vector3):
	return linear_velocity + angular_velocity.cross(point - global_position)

func _calculate_suspension(raycast: RayCast3D):
	if(!raycast.is_colliding()):
		return
	
	#esto hace que la pulling force del car se vaya, así solo trabaja en valores negativos
	#creo que si quitamos esto, el coche hace que se pueda pegar a las paredes
	#según el vídeo si le metes un +0.2 despues de wheel_radius, el coche se pega un poquito al suelo
	raycast.target_position.y = -(suspension_rest_distance + wheel_radius)
	
	var collision_point = raycast.get_collision_point()
	var spring_direction_up: Vector3 = raycast.global_transform.basis.y
	var spring_length = raycast.global_position.distance_to(collision_point) - wheel_radius
	var offset = suspension_rest_distance - spring_length
	
	raycast.get_node("Wheel").position.y = -spring_length
	
	var spring_force = spring_strength * offset
	
	var world_velocity = _get_point_velocity(collision_point)
	var relative_velocity = spring_direction_up.dot(world_velocity)
	var spring_damping_force = spring_damping * relative_velocity
	
	var force_vector = (spring_force - spring_damping_force) * spring_direction_up 
	
	var force_position_offset = collision_point - global_position
	
	apply_force(force_vector, force_position_offset)
	
	

func _calculate_steering(raycast: RayCast3D) -> Vector3:
	return Vector3.UP

func _calculate_acceleration(raycast: RayCast3D) -> Vector3:
	return Vector3.UP
