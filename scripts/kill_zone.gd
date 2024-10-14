extends Area2D

@export var damage := 1

func _process(_delta: float) -> void:
	for body in get_overlapping_bodies():
		if body is Player:
			var knockback_direction = sign(body.global_position.x - global_position.x)
			body.state_machine._on_state_transitioned('hit', {'knockback_dir': knockback_direction})
