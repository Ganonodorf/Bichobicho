class_name LocalForce

var force: Vector3
var position: Vector3


func _init(force: Vector3 = Vector3.ZERO, position: Vector3 = Vector3.ZERO):
	self.force = force
	self.position = position

func get_force() -> Vector3:
	return force

func get_position() -> Vector3:
	return position

func _to_string() -> String:
	return "Force: " + str(force) + "||Position: " + str(position)
