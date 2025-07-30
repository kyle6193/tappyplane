extends RigidBody2D

var impulse_force : int = 1200

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		apply_central_impulse(Vector2.UP * impulse_force)
