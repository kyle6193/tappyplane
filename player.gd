extends RigidBody2D

var impulse_force : int = 1200

func _process(delta):
	if Input.is_action_just_pressed("click"):
		apply_central_force(Vector2.UP * impulse_force)
		
