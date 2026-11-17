@tool
extends EditorScenePostImport

var auto_interactable_scene_packed = preload("res://Interactions/auto_interactable_for_import.tscn")
var manual_interactable_scene_packed = preload("res://Interactions/manual_interactable_for_import.tscn")
var spawnpoint_scene_packed = preload("res://Level/components/spawn_point.tscn")

func _post_import(scene: Node) -> Object:
	var auto_int_nodes: Array = []
	_find_auto_interactables(scene, auto_int_nodes)
	print("found auto interactables: ", auto_int_nodes)
	_add_auto_interactables(scene, auto_int_nodes)
	
	var manual_int_nodes: Array = []
	_find_manual_interactables(scene, manual_int_nodes)
	print("found manual interactables: ", manual_int_nodes)
	_add_manual_interactables(scene, manual_int_nodes)
	
	var sp_nodes: Array = []
	_find_spawnpoints(scene, sp_nodes)
	print("found spawnpoints: ", sp_nodes)
	_add_spawnpoints(scene, sp_nodes)
	
	return scene

func _find_auto_interactables(node: Node, _auto_interactable_nodes: Array) -> void:
	for child in node.get_children():
		_find_auto_interactables(child, _auto_interactable_nodes)
	if node.name.begins_with("AUTO-INT-"):
		_auto_interactable_nodes.append(node)

func _find_manual_interactables(node: Node, _manual_interactable_nodes: Array) ->void:
	for child in node.get_children():
		_find_manual_interactables(child, _manual_interactable_nodes)
	if node.name.begins_with("MANUAL-INT-"):
		_manual_interactable_nodes.append(node)

func _find_spawnpoints(node: Node, _spawnpoint_nodes: Array) -> void:
	for child in node.get_children():
		_find_spawnpoints(child, _spawnpoint_nodes)
	if node.name.begins_with("SP-"):
		_spawnpoint_nodes.append(node)

func _add_auto_interactables(scene :Node, auto_int_nodes :Array) -> void:
	for node in auto_int_nodes:
		var original_transform = _get_world_transfrom(node, scene)
		
		if node.mesh == null:
			push_warning("AUTO-INT- node has no mesh, skipping: " + node.name)
			continue
		
		var auto_interactable = auto_interactable_scene_packed.instantiate()
		scene.add_child(auto_interactable)
		auto_interactable.owner = scene
		auto_interactable.transform = original_transform
		auto_interactable.name = "Auto-Int " + node.name
		
		var shape = node.mesh.create_convex_shape()
		var area3d = Area3D.new()
		auto_interactable.add_child(area3d)
		area3d.owner = scene
		
		var collision_shape = CollisionShape3D.new()
		collision_shape.shape = shape
		area3d.add_child(collision_shape)
		collision_shape.owner = scene
		
		area3d.set_collision_mask_value(2,true)
		area3d.set_collision_mask_value(1,false)
		
		node.visible = false

func _add_manual_interactables(scene: Node, manual_int_nodes: Array) ->void:
	for node in manual_int_nodes:
		var original_transform = _get_world_transfrom(node, scene)
		
		if node.mesh == null:
			push_warning("MANUAL-INT- node has no mesh, skipping: " + node.name)
			continue
		
		var manual_interactable = manual_interactable_scene_packed.instantiate()
		scene.add_child(manual_interactable)
		manual_interactable.owner = scene
		manual_interactable.transform = original_transform
		manual_interactable.name = "Manual-Int " + node.name
		
		var node_copy = node.duplicate()
		scene.add_child(node_copy)
		node_copy.reparent(manual_interactable, false)
		node_copy.transform = Transform3D.IDENTITY
		node_copy.owner = scene
		
		var shape = node.mesh.create_convex_shape()
		
		var staticbody3d = StaticBody3D.new()
		node_copy.add_child(staticbody3d)
		staticbody3d.owner = scene
		
		var collision_shape = CollisionShape3D.new()
		collision_shape.shape = shape
		staticbody3d.add_child(collision_shape)
		collision_shape.owner = scene
		
		staticbody3d.set_collision_layer_value(1,true)
		staticbody3d.set_collision_layer_value(2,true)
		
		node.visible = false

func _add_spawnpoints(scene :Node, sp_nodes :Array) -> void:
		
	for node in sp_nodes:
		var original_transform = _get_world_transfrom(node, scene)
		
		var spawnpoint = spawnpoint_scene_packed.instantiate()
		scene.add_child(spawnpoint)
		spawnpoint.owner = scene
		spawnpoint.transform = original_transform
		spawnpoint.name = "Sp " + node.name
		
		node.visible = false
	


# hace falta calcular este global transform manualmente porque este postimport script
# corre cuando aún no hay una escena por lo que no puede calcular global_transform
func _get_world_transfrom(node: Node3D, scene_root: Node3D) -> Transform3D:
	var combined_transform = node.transform
	var parent = node.get_parent()
	while parent != null and parent != scene_root and parent is Node3D:
		combined_transform = parent.transform * combined_transform
		parent = parent.get_parent()
	return combined_transform
