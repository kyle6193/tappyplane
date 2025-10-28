extends Node

@export var obstacle : PackedScene
@export var coin : PackedScene

var ranspan_pos : String
var dynamic_object_speed : int = 500
var health_decrease_speed : int = 3
var spawned_object_pos_x :int = 1700
var health : float = 100.0
var score : float

func _process(delta: float) -> void:
	for i in get_tree().get_nodes_in_group("Dynamic_Objects"):
		i.position.x -= delta * dynamic_object_speed
		# This moves each node within the "Dynamic Objects" group left by the same amount each frame
		# Including delta in the equation ensures framerates and etc don't change the speed
	
	if health > 0:
		health -= delta * health_decrease_speed # Takes the above health float, and decreases every second
		$UI/HealthBar.value = health
		'''
		You can't initially edit child values (we're currently on the "Main" node), so to do so you
		use the $ and a path to gain access to the desired node's values. The above code accesses
		the HeathBar's "value" and links it with the float to cause it to decrease each second.
		'''
	else:
		game_over()

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

func _on_spawner_timer_timeout() -> void:
	var random : int = randi() % 2 
	'''
	% 2 is modular math. Mod 2 means the result can only be 0 or 1. If it was % 3 it would be 0, 1, 2 and so on.
	Look it up for a deep dive. Basically it answers "If I divide these two numbers, what's the remainder?"
	'''
	var obstacle_instance : Area2D = obstacle.instantiate() #Adds the obstacle to memory but that's it
	add_child(obstacle_instance) #Adds the obstacle to the scene tree and renders it on screen
	obstacle_instance.position.x = spawned_object_pos_x # Sets the obstacle's horizontal (x) position to 1700, which is off-screen to the right.
	if random == 0:
		obstacle_instance.position.y = 88
		ranspan_pos = "up"
	if random == 1:
		obstacle_instance.position.y = 420
		obstacle_instance.scale.y *= -1 #Flips the obstacle vertically by multiplying its y-scale by -1
		ranspan_pos = "down"
	obstacle_instance.body_entered.connect(_on_obstacle_collided) # See comment in _on_coin_timer_timeout() below

func _on_coin_timer_timeout() -> void:
	var random: int = randi() % 3
	var coin_instance : Area2D = coin.instantiate()
	add_child(coin_instance)
	coin_instance.position.x = spawned_object_pos_x
	if random == 0 and ranspan_pos == "up":
		return
	if random == 2 and ranspan_pos == "down":
		return
		# if the the obstacle and coin would spawn in the same slot, the function "returns" meaning it exits the if clause

	else:
		coin_instance.position.y = 120 + random * 120
		'''
		This sets the coin's vertical (y) position based on the random number generated:
			- If random is 0, y = 120
			- If random is 1, y = 240
			- If random is 2, y = 360
		'''

	coin_instance.body_entered.connect(_on_coin_collided.bind(coin_instance))
	'''
	.body_entered is a signal emitted when another body enters the Area2D. It's coded here since the node spawns during runtime.
	connect() links a signal to a function so that when the signal is emitted, the function is called.
	bind() sends the named node to the "connected" function as an additional argument.
	This is important because it's sending the exact coin that was collided.
	'''

func _on_coin_collided(body: Node, coin_instance: Area2D) -> void:
	if body.is_in_group("Player"): # Check if the colliding body is in the "Player" group
		health += 4
		coin_instance.get_node("AnimationPlayer").play("CoinCollected")
		#coin_instance.queue_free() # queue_free() safely deletes the node after the current frame and frees up memory.
		if health > 100:
			health = 100

func _on_obstacle_collided(body: Node2D) -> void:
	if body.is_in_group("Player"):
		game_over()

func game_over() -> void:
	$GameOver.show()
	get_tree().paused = true
