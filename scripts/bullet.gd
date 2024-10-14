extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const BULLET_SPEED: float = 500.0
var direction: int = 0

func _process(delta: float) -> void:
	position.x += BULLET_SPEED * direction * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.state_machine._on_state_transitioned('hit', {'knockback_dir': direction })
	animation_player.play("destroy")
