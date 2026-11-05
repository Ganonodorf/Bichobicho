extends RigidBody3D
class_name RaycastCar

@export var acceleration: float = 600.0
@export var acceleration_curve: Curve
@export var max_speed: float = 20.0

var wheels: Array[RaycastWheel]

var motor_input: int = 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("car_accelerate"):
		motor_input = 1
	elif event.is_action_released("car_accelerate"):
		motor_input = 0
	
	if event.is_action_pressed("car_brake"):
		motor_input = -1
	elif event.is_action_released("car_brake"):
		motor_input = 0

func _ready() -> void:
	wheels.append($WheelFrontLeft)
	wheels.append($WheelFrontRight)
	wheels.append($WheelRearLeft)
	wheels.append($WheelRearRight)

func _physics_process(delta: float) -> void:
	var grounded: bool = false
	var turn_input = Input.get_axis("car_right", "car_left")
	
	for wheel: RaycastWheel in wheels:
		if(wheel.is_colliding()):
			grounded = true
		
		if(wheel.is_rotate):
			wheel.steering_rotation(delta, turn_input)
		
		wheel.force_raycast_update()
		wheel.apply_suspension_force()
		wheel.apply_wheel_acceleration(acceleration, motor_input, max_speed, acceleration_curve)
		wheel.apply_wheel_traction(_wheel_number())
	
	# Se puede poner esto para bajar el centro de gravedad si lo queremos cuando el coche esté
	# en el aire, así previenes que vuelque
	if grounded:
		self.center_of_mass = Vector3.ZERO
	else:
		center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
		center_of_mass = Vector3.DOWN * 0.5
		

func _wheel_number() -> int:
	return wheels.size()
