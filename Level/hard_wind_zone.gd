extends Area3D

@export var force: float = 0
@export var strike_time: float = 0.3

var count: float = 0
var bichos: Array[Node3D] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(count > strike_time):
		_apply_wind()
		count = 0
		return
	
	count += delta


func _apply_wind() -> void:
	for bicho in bichos:
		var impulse_vector = force * Vector3.FORWARD
		bicho.apply_impulse(impulse_vector, bicho.global_position)
	pass


func _add_bicho(body: Node3D) -> void:
	bichos.append(body)
	pass


func _erase_bicho(body: Node3D) -> void:
	bichos.erase(body)
	pass


func _on_body_entered(body: Node3D) -> void:
	if(body.is_in_group('Bichos')):
		_add_bicho(body)
	pass # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	if(body.is_in_group('Bichos')):
		_erase_bicho(body)
	pass # Replace with function body.
