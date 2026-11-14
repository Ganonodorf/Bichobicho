@tool
extends EditorScenePostImport

var interactable_scene_packed = preload("res://Interactions/interactable.tscn")

func _post_import(scene: Node) -> Object:
	var int_nodes: Array = []
	_find_interactables(scene, int_nodes)
	print("found interactables: ", int_nodes)
	
	for node in int_nodes:
		var original_transform = _get_world_transfrom(node, scene)
		
		var interactable = interactable_scene_packed.instantiate()
		scene.add_child(interactable)
		interactable.owner = scene
		interactable.transform = original_transform
		interactable.name = "Int " + node.name
		
		var node_copy :Node = node.duplicate()
		scene.add_child(node_copy)
		node_copy.reparent(interactable, false)
		node_copy.transform = Transform3D.IDENTITY
		node_copy.owner = scene
		print("copied nodes: ",node_copy)
		
		node.visible = false
	
	return scene

func _find_interactables(node: Node, _interactable_nodes: Array) -> void:
	for child in node.get_children():
		_find_interactables(child, _interactable_nodes)
	if node.name.begins_with("INT-"):
		_interactable_nodes.append(node)

# hace falta calcular este global transform manualmente porque este postimport script
# corre cuando aún no hay una escena por lo que no puede calcular global_transform
func _get_world_transfrom(node: Node3D, scene_root: Node3D) -> Transform3D:
	var combined_transform = node.transform
	var parent = node.get_parent()
	while parent != null and parent != scene_root and parent is Node3D:
		combined_transform = parent.transform * combined_transform
		parent = parent.get_parent()
	return combined_transform
