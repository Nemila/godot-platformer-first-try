extends RigidBody2D

const BULLET_SPEED: float = 400.0
var direction: int = 0

func _ready() -> void:
	linear_velocity.x = BULLET_SPEED * direction

func reverse_direction() -> void:
	linear_velocity.x = BULLET_SPEED * -direction

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.knockback.call_deferred(direction)
	$AnimationPlayer.play("broken")
