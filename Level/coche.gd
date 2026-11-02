extends RigidBody3D

var wheels: Array[RayCast3D]
@export var spring_strength: float = 150
@export var spring_damping: float = 15.0
@export var suspension_rest_distance: float = 0.5

func _ready() -> void:
	wheels.append($WheelFrontLeft)
	wheels.append($WheelFrontRight)
	wheels.append($WheelRearLeft)
	wheels.append($WheelRearRight)

func _physics_process(delta: float) -> void:
	
	print("")
	for raycast: RayCast3D in wheels:
		if(raycast.is_colliding()):
			print("raycast: ", raycast.name)
			var suspension_force: Vector3 = _calculate_suspension(raycast)
			#_calculate_steering(raycast)
			#_calculate_acceleration(raycast)
			print("raycast.global_position: ", raycast.global_position)
			print("suspension_force: ", suspension_force)
			self.apply_force(suspension_force, raycast.global_position)
			DebugDraw3D.draw_arrow(raycast.global_position, suspension_force, Color(1.0, 1.0, 0.0, 1.0))


func _calculate_suspension(raycast: RayCast3D) -> Vector3:
	var spring_direction: Vector3 = raycast.global_transform.basis.y
	
	var tire_world_velocity: Vector3 = linear_velocity + angular_velocity.cross(raycast.global_position - global_transform.origin)
	
	var raycast_offset: float = raycast.get_collision_point().distance_to(raycast.global_position) - suspension_rest_distance
	
	var spring_velocity: float  = spring_direction.dot(tire_world_velocity)
	
	var dampened_string_force = (raycast_offset * spring_strength) - (spring_velocity * spring_damping)
	
	return spring_direction * dampened_string_force

func _calculate_steering(raycast: RayCast3D) -> Vector3:
	return Vector3.UP

func _calculate_acceleration(raycast: RayCast3D) -> Vector3:
	return Vector3.UP
