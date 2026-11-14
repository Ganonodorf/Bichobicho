extends Node

@export var interact_flag :Label = null

func set_interact_flag(active :bool) ->void:
	interact_flag.visible = active
