extends Area3D

var count: float = 0
@export var change_speed: float = 1;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(count > change_speed):
		count = 0
		wind_force_magnitude = randf_range(0.1, 1)
		
		return
	
	count += delta
	
	pass
