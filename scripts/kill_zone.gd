extends Area2D

func _process(_delta: float) -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			var knockback_direction = sign(body.position.x - get_parent().position.x)
			body.take_damage.call_deferred(knockback_direction)
