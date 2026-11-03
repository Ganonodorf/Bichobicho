extends RigidBody3D
class_name RaycastCar

var wheels: Array[RaycastWheel]
@export var acceleration: float = 600.0

func _ready() -> void:
	wheels.append($WheelFrontLeft)
	wheels.append($WheelFrontRight)
	wheels.append($WheelRearLeft)
	wheels.append($WheelRearRight)

func _physics_process(delta: float) -> void:
	for wheel: RaycastWheel in wheels:
		wheel.apply_suspension_force()
		#_calculate_suspension(wheel)
		#_calculate_steering(raycast)
		#_calculate_acceleration(raycast)
	

func _calculate_steering(wheel: RayCast3D) -> Vector3:
	return Vector3.UP

func _calculate_acceleration(wheel: RayCast3D) -> Vector3:
	return Vector3.UP
