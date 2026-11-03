extends RayCast3D
class_name RaycastWheel

@export var spring_strength: float = 100.0
@export var spring_damping: float = 2.0
@export var suspension_rest_distance: float = 0.5
@export var over_extend: float = 0.0
@export var wheel_radius = 0.45

@onready var wheel_mesh: Node3D = get_child(0)


func apply_suspension_force():
	if(!self.is_colliding()):
		return
	
	#esto hace que la pulling force del car se vaya, así solo trabaja en valores negativos
	#creo que si quitamos esto, el coche hace que se pueda pegar a las paredes
	#el over_extend es para que el coche se pegue un poquito al suelo
	self.target_position.y = -(self.suspension_rest_distance + self.wheel_radius + self.over_extend)
	
	var collision_point = self.get_collision_point()
	var spring_direction_up: Vector3 = self.global_transform.basis.y
	var spring_length = self.global_position.distance_to(collision_point) - self.wheel_radius
	var offset = self.suspension_rest_distance - spring_length
	
	self.wheel_mesh.position.y = -spring_length
	
	var spring_force = self.spring_strength * offset
	
	var world_velocity = _get_point_velocity(collision_point)
	var relative_velocity = spring_direction_up.dot(world_velocity)
	var spring_damping_force = self.spring_damping * relative_velocity
	
	var force_vector = (spring_force - spring_damping_force) * spring_direction_up 
	
	var force_position_offset = collision_point - self.get_parent().global_position
	
	self.get_parent().apply_force(force_vector, force_position_offset)


func _get_point_velocity(point: Vector3):
	return self.get_parent().linear_velocity + self.get_parent().angular_velocity.cross(point - self.get_parent().global_position)
