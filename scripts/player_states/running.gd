extends State

@onready var player: Player = owner
@export var animation_name: String

func enter(_prev_state_name: String, _data: Dictionary = {}) -> void:
	if animation_name:
		player.animation_player.play(animation_name)


func update(_delta: float) -> void:
	player.direction = Input.get_axis("move_left", "move_right")
	
	if player.is_on_floor():
		if Input.is_action_pressed("jump"):
			transitioned.emit("jumping")
		elif player.direction == 0:
			transitioned.emit("idle")
	else:
		transitioned.emit("falling")


func exit() -> void:
	pass
