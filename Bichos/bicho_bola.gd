extends RigidBody3D

class_name Bicho_Bola

var patas: Array[Pata]

var is_bola: bool = false

@export var animation_player: AnimationPlayer
@export var original_shape1: CollisionShape3D
@export var original_shape2: CollisionShape3D
@export var bola_shape: CollisionShape3D

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

		if(Input.is_action_just_pressed("D_key")):
			_transform()
	
	if(move):
		animation_player.stop()
		animation_player.play("Move")
		pass
	
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "Move"):
		animation_player.play("Idle")
		
	pass

func _transform() -> void:
	if(is_bola):
		_set_initial_shape()
	else:
		_set_bola_shape()
	pass

func _set_initial_shape() -> void:
	is_bola = false
	original_shape1.disabled = false
	original_shape2.disabled = false
	bola_shape.disabled = true
	pass
	
func _set_bola_shape() -> void:
	is_bola = true
	original_shape1.disabled = true
	original_shape2.disabled = true
	bola_shape.disabled = false
	pass
