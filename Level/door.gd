class_name Door extends Area3D

@export var origin_level: String
@export var destiny_level: String

var destination_node: Node3D

var levels: Array[Level]

func _ready() -> void:
	destination_node = $Destination

func _on_body_entered(body: Node3D) -> void:
	if(body.is_in_group("bichero")):
		for level in levels:
			level.notify(destiny_level, origin_level)

func add_observer(level: Level):
	levels.append(level)

func get_destination_position():
	return destination_node.global_position

func is_your_other_side(origin_level: String, destiny_level: String) -> bool:
	return self.origin_level == origin_level && self.destiny_level == destiny_level
