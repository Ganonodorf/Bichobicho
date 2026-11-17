extends Interactable2

@export var mesh_node :MeshInstance3D = null

func _ready() -> void:
	super()
	if mesh_node == null:
		mesh_node = _find_mesh_instance_in_children(self)
	if mesh_node != null:
		_override_material_with_copy(mesh_node)
	if _player_is_first_person():
		_delete_area3d()
	else:
		_deactivate_collision_layer2()

func _on_area_3d_body_entered(_body: Node3D) -> void:
	if manager:
		manager.add_interactable(self)

func _on_area_3d_body_exited(_body: Node3D) -> void:
	if manager:
		manager.remove_interactable(self)

func _find_mesh_instance_in_children(node: Node3D) -> MeshInstance3D:
	for child in node.get_children():
		var result = _find_mesh_instance_in_children(child)
		if result: 
			return result
	if node is MeshInstance3D:
		return node
	return null

func _override_material_with_copy(mesh :MeshInstance3D) -> void:
	# esto substituye el material por una copia nueva para cada interactable
	if mesh != null:
		var original_mat = mesh.get_active_material(0)
		var override_mat: StandardMaterial3D
		if original_mat != null:
			override_mat = original_mat.duplicate()
		else:
			override_mat = StandardMaterial3D.new()
		mesh.set_surface_override_material(0, override_mat)

func _player_is_first_person() -> bool:
	var player = get_tree().get_first_node_in_group("player")
	if player != null:
		if player.is_in_group("bichocoche"):
			return false
	return true

func _delete_area3d() -> void:
	var area3d = _find_area3d_in_children(self)
	if area3d:
		area3d.free()

func _deactivate_collision_layer2() -> void:
	var static_body = _find_staticbody3d_instance_in_children(self)
	if static_body:
		static_body.set_collision_layer_value(2,false)

func _find_staticbody3d_instance_in_children(node: Node3D) -> StaticBody3D:
	for child in node.get_children():
		var result = _find_staticbody3d_instance_in_children(child)
		if result: 
			return result
	if node is StaticBody3D:
		return node
	return null

func show_outline(enable: bool) -> void:
	if mesh_node == null:
		return
	var mat = mesh_node.get_surface_override_material(0)
	if mat == null:
		return
	mat.emission_enabled = enable
	mat.emission = Color(0.985, 0.501, 0.0, 1.0)
	mat.emission_energy_multiplier = 0.2
