class_name Custom_timer extends Node

var _counter: float = 0
var _limit: float

func _init(limit: float):
	_limit = limit

func _process(delta: float) -> void:
	_counter += delta

func _reset() -> void:
	_counter = 0

func _is_off_limit() -> bool:
	return _counter > _limit

func _get_count() -> float:
	return _counter
