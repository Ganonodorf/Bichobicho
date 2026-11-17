extends Interactable2

func _on_area_3d_body_entered(_body: Node3D) -> void:
	interact()

func _on_area_3d_body_exited(_body: Node3D) -> void:
	interact()
