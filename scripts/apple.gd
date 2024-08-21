extends Area2D

@onready var control: Node = %Control

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		control.add_score.call_deferred(1)
		$AnimationPlayer.play("pickup")
