extends Node

var dynamic_object_speed : int = 700

func _process(delta: float) -> void:
	for i in get_tree().get_nodes_in_group("Dynamic_Objects"):
		i.position.x -= delta * dynamic_object_speed
