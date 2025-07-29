extends Node2D

func _process(_delta: float) -> void:
	if position.x <= -800:
		position.x = 0
