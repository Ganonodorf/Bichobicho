extends VehicleBody3D

@export var maximum_rpm = 450
@export var maximum_torque = 300
@export var slide_rpm = 300
@export var turn_speed = 3
@export var turn_amount = 0.3

var wheels: Array[VehicleWheel3D]

func _ready() -> void:
	wheels.append($WheelRearLeft)
	wheels.append($WheelRearRight)

func _physics_process(delta: float) -> void:
	$SpringArm3D.position = position
	
	var dir = Input.get_action_strength("bichero_up") - Input.get_action_strength("bichero_down")
	var steering_dir = Input.get_action_strength("bichero_left") - Input.get_action_strength("bichero_right")
	
	var RPM_left = abs($WheelRearLeft.get_rpm())
	var RPM_right = abs($WheelRearRight.get_rpm())
	var RPM = (RPM_left + RPM_right) / 2.0
	
	var torque = dir * maximum_torque * (1.0 - RPM / maximum_rpm)
	
	engine_force = torque
	steering = lerp(steering, steering_dir * turn_amount, turn_speed * delta)
	
	if dir == 0:
		brake = 2
	
	print(RPM)
	
	if(RPM > slide_rpm):
		for wheel in wheels:
			wheel.wheel_friction_slip = 0.0
	else:
		for wheel in wheels:
			wheel.wheel_friction_slip = 1.0
