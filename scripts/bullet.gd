extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const BULLET_SPEED: float = 500.0

var direction: int = 0

func _process(delta: float) -> void:
	position.x += BULLET_SPEED * direction * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage.call_deferred(direction)
	animation_player.play("destroy")
