extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.velocity.y = -450 * 1.5
		$AnimatedSprite2D.play("jump")
