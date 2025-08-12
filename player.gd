extends RigidBody2D

var impulse_strength : int = 1200

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		apply_central_impulse(Vector2.UP * impulse_strength)
		'''
		apply_central_impulse is used instead of apply_impulse because the
		first option doesn't cause the sprite to rotate/spin upon click
		'''
