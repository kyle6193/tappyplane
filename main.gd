extends Node

var dynamic_object_speed : int = 700
var health_decrease_speed : int = 3
var health : float = 100.0
var score : float

func _process(delta: float) -> void:
	for i in get_tree().get_nodes_in_group("Dynamic_Objects"):
		i.position.x -= delta * dynamic_object_speed
		# This moves each node within the "Dynamic Objects" group left by the same amount each frame
		# Including delta in the equation ensures framerates and etc don't change the speed
	
	if health > 0:
		health -= delta * health_decrease_speed
		$UI/HealthBar.value = health
		'''
		The $ connects to the scene tree up to where the script is attached.
		This is why this is attached to the main node, so that we have
		access to the entire scene's tree of nodes
		'''
	
	score += delta # increase score every second
	var formatted_score : String = str(score) # format score into a String
	formatted_score = "%.2f" % score 
	$UI/HealthBar/ScoreLabel.text = formatted_score # display score on label
	'''
	Explanation of "%.2f" % score:
		- "%.2f" is a format string:
				- % indicates formatting will occur.
				- .2 means 2 decimal places
				- f means float
		- % score applies the format string to the value of 'score'.
		- The result is a string of 'score' rounded to two decimal places.
	'''
