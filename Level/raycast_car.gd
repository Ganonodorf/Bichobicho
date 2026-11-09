extends RigidBody3D
class_name RaycastCar

@export_group("Car")
@export var center_of_mass_on_air = Vector3.DOWN * 0.5
@export_group("Engine")
@export var acceleration_value: float = 600.0
@export var acceleration_curve: Curve
@export var max_speed: float = 20.0

@export_group("Camera")
@export var mouse_sensitivity: float = 0.05
@export var min_pitch: float = -40.0
@export var max_pitch: float = 20.0

@export_group("Skid marks")
@export var skid_marks: Array[GPUParticles3D]

@export_group("Input names")
@export var acceleration: String = "car_accelerate"
@export var decceleration: String = "car_brake"
@export var brake: String = "hand_brake"
@export var right: String = "car_right"
@export var left: String = "car_left"

@onready var phantom_camera: PhantomCamera3D = get_node_or_null("../PhantomCamera3D")

var wheels: Array[RaycastWheel]

var motor_input: int = 0
var turn_input: float = 0
var hand_brake: bool = false

func _ready() -> void:
	wheels.append($WheelFrontLeft)
	wheels.append($WheelFrontRight)
	wheels.append($WheelRearLeft)
	wheels.append($WheelRearRight)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM

func _physics_process(delta: float) -> void:
	var is_grounded: bool = false
	var turn_input = Input.get_axis(right, left)
	
	for i in wheels.size():
		if wheels[i].is_colliding() && is_grounded != true:
			is_grounded = true
		
		if wheels[i].is_rotate:
			wheels[i].steering_rotation(delta, turn_input)
		
		wheels[i].force_raycast_update()
		wheels[i].apply_suspension_force()
		wheels[i].apply_wheel_acceleration(acceleration_value, motor_input, max_speed, acceleration_curve)
		wheels[i].apply_wheel_traction(hand_brake, _wheel_number(), skid_marks[i])
	
	_update_center_of_mass(is_grounded)

func _update_center_of_mass(is_grounded: bool):
	# Se puede poner esto para bajar el centro de gravedad si lo queremos cuando el coche esté
	# en el aire, así previenes que vuelque
	if is_grounded && center_of_mass != Vector3.ZERO:
		center_of_mass = Vector3.ZERO
	elif !is_grounded && center_of_mass != center_of_mass_on_air:
		center_of_mass = center_of_mass_on_air

func _unhandled_input(event: InputEvent) -> void:
	# For the phantom camera
	if event is InputEventMouseMotion and phantom_camera:
		var rot = phantom_camera.get_third_person_rotation_degrees()
		rot.x -= event.relative.y * mouse_sensitivity
		rot.x = clampf(rot.x, min_pitch, max_pitch)
		rot.y -= event.relative.x * mouse_sensitivity
		rot.y = wrapf(rot.y, 0.0, 360.0)
		phantom_camera.set_third_person_rotation_degrees(rot)

	if event.is_action_pressed(acceleration):
		motor_input = 1
	elif event.is_action_released(acceleration):
		motor_input = 0
	
	if event.is_action_pressed(decceleration):
		motor_input = -1
	elif event.is_action_released(decceleration):
		motor_input = 0
	
	if event.is_action_pressed(brake):
		hand_brake = true
	elif event.is_action_released(brake):
		hand_brake = false

func _wheel_number() -> int:
	return wheels.size()
