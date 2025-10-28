extends RigidBody2D

var impulse_strength : int = 1200

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		apply_central_impulse(Vector2.UP * impulse_strength)
		'''
		apply_central_impulse is used instead of apply_impulse because the
		first option doesn't cause the sprite to rotate/spin upon click
		'''
	$Particles.position = Vector2(position.x -50, position.y -20)
	'''
	Since this line of code is attached to the player instead of the particle, 
	this position is relative to the player. As we've seen previously the $ calls
	a node that is a child of the current node.
	'''
