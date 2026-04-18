extends RigidBody3D

class_name Bicho

var patas: Array[Pata]

@onready var animation_player: AnimationPlayer = $bichoTest/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Pata:
			patas.append(child)
			
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move: bool = false
	
	if(Input):
		for pata in patas:
			if Input.is_action_just_pressed(pata.key_name):
				pata.applyImpulse()
				move = true
	
	if(move):
		animation_player.play("Move")
		pass
	
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "Move"):
		animation_player.play("Idle")
		
	pass
