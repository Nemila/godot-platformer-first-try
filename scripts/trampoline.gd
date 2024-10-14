extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.state_machine._on_state_transitioned('jumping', {'jump_speed': -700})
