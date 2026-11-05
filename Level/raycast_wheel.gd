extends RayCast3D
class_name RaycastWheel

@export var spring_strength: float = 5000.0
@export var spring_damping: float = 200.0
@export var suspension_rest_distance: float = 0.5
@export var over_extend: float = 0.2
@export var wheel_radius: float = 0.45
@export var is_motor: bool = false
@export var is_rotate: bool = false
@export var deceleration: float = 200
@export var motor_deceleration_threshold: float = 0.1
@export var tire_turn_speed: float = 2.0
@export var tire_max_turn_degrees: float = 25.0
@export var x_traction: float = 1.0
@export var use_projected_vector: bool = false

@onready var wheel_mesh: Node3D = get_child(0)

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	self.enabled = false

func apply_suspension_force():
	if(!self.is_colliding()):
		return
	
	#esto hace que la pulling force del car se vaya, así solo trabaja en valores negativos
	#creo que si quitamos esto, el coche hace que se pueda pegar a las paredes
	#el over_extend es para que el coche se pegue un poquito al suelo
	self.target_position.y = -(self.suspension_rest_distance + self.wheel_radius + self.over_extend)
	
	var collision_point = self.get_collision_point()
	var spring_direction_up = self.global_transform.basis.y
	var spring_length = self.global_position.distance_to(collision_point) - self.wheel_radius
	var offset = self.suspension_rest_distance - spring_length
	
	self.wheel_mesh.position.y = -spring_length
	
	var spring_force = self.spring_strength * offset
	
	var world_velocity = _get_point_velocity(collision_point)
	var relative_velocity = spring_direction_up.dot(world_velocity)
	var spring_damping_force = self.spring_damping * relative_velocity
	
	var force_vector = (spring_force - spring_damping_force) * self.get_collision_normal()
	
	var force_apply_point = self.wheel_mesh.global_position
	var force_position_offset = force_apply_point - self.get_parent().global_position
	
	self.get_parent().apply_force(force_vector, force_position_offset)

func apply_wheel_acceleration(acceleration: float, motor_input: int, max_speed: float, acceleration_curve: Curve):
	var forward_direction = -self.global_basis.z
	var car_velocity = forward_direction.dot(self.get_parent().linear_velocity)
	self.wheel_mesh.rotate_x((-car_velocity * self.get_parent().get_process_delta_time()) / self.wheel_radius)
	
	if(!self.is_colliding()):
		return
	
	var force_apply_point = self.wheel_mesh.global_position
	var force_position = force_apply_point - self.get_parent().global_position
	
	if(is_motor and motor_input):
		var speed_ratio = car_velocity / max_speed
		var acceleration_curve_ratio = acceleration_curve.sample_baked(speed_ratio)
		var force_vector = forward_direction * acceleration * motor_input * acceleration_curve_ratio
		var projected_vector: Vector3 = (force_vector - self.get_collision_normal() * force_vector.dot(self.get_collision_normal()))
		
		if(use_projected_vector):
			self.get_parent().apply_force(projected_vector, force_position)
		else:
			self.get_parent().apply_force(force_vector, force_position)
	
	#Para que desacelere él
	elif(abs(car_velocity) > motor_deceleration_threshold and !motor_input):
		var drag_force_vector = global_basis.z * deceleration * signf(car_velocity)
		self.get_parent().apply_force(drag_force_vector, force_position)

func steering_rotation(delta: float, turn_input: float):
	var turn_value = turn_input * tire_turn_speed
	if(turn_value):
		self.rotation.y = clampf(self.rotation.y + turn_value * delta, deg_to_rad(-tire_max_turn_degrees), deg_to_rad(tire_max_turn_degrees))
	else:
		self.rotation.y = move_toward(self.rotation.y, 0, tire_turn_speed * delta)

func apply_wheel_traction(wheel_number: int):
	if(!self.is_colliding()):
		return
	
	var steer_side_direction = self.global_basis.x
	var tire_velocity = _get_point_velocity(self.wheel_mesh.global_position)
	var steering_x_velocity = steer_side_direction.dot(tire_velocity)
	
	# El pive no hace esto porque dice que es overkill
	#var desired_acceleration = (steering_x_velocity * x_traction) / get_physics_process_delta_time()
	#var x_force = -steer_side_direction * desired_acceleration * (self.get_parent().mass/wheel_number)
	var x_force = -steer_side_direction * steering_x_velocity * x_traction * ((self.get_parent().mass * gravity)/wheel_number)
	
	var force_position = self.wheel_mesh.global_position - global_position
	self.get_parent().apply_force(x_force, force_position)
	
func _get_point_velocity(point: Vector3):
	return self.get_parent().linear_velocity + self.get_parent().angular_velocity.cross(point - self.get_parent().global_position)
