extends Area3D

@export var force: float = 0
@export var force_interval_time: float = 4
@export var viento_activado: CSGBox3D
@export var viento_desactivado: CSGBox3D

var bichos: Array[Node3D] = []
var count: float = 0
var is_wind_active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(count > force_interval_time):
		count = 0
		_trigger_wind()
	else:
		count += delta
	pass

func _on_body_entered(body: Node3D) -> void:
	if(body.is_in_group('Bichos')):
		if(is_wind_active):
			body.add_constant_central_force(force * global_transform.basis.z)
		bichos.append(body)
	pass # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	if(body.is_in_group('Bichos')):
		if(is_wind_active):
			body.add_constant_central_force(-force * global_transform.basis.z)
		bichos.erase(body)
	pass # Replace with function body.
	
func _trigger_wind():
	if(is_wind_active):
		_deactivate_wind()
		_delete_force_from_bichos()
	else:
		_activate_wind()
		_add_force_to_bichos()

func _deactivate_wind():
	if(viento_activado != null):
		viento_activado.hide()
	if(viento_activado != null):
		viento_desactivado.show()
	is_wind_active = false

func _activate_wind():
	if(viento_activado != null):
		viento_activado.show()

	if(viento_activado != null):
		viento_desactivado.hide()
	is_wind_active = true
	
func _delete_force_from_bichos():
	for bicho in bichos:
		bicho.add_constant_central_force(-force * global_transform.basis.z)
	
func _add_force_to_bichos():
	for bicho in bichos:
		bicho.add_constant_central_force(force * global_transform.basis.z)
	
