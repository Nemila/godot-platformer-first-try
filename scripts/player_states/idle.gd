extends State

@onready var player: Player = owner
@export var animation_name: String

func enter(_prev_state_name: String, _data: Dictionary = {}) -> void:
	if animation_name:
		player.animation_player.play(animation_name)


func update(_delta: float) -> void:
	player.direction = Input.get_axis("move_left", "move_right")
	
	if player.direction and player.is_on_floor():
		transitioned.emit("running")
	elif Input.is_action_pressed("jump") and player.is_on_floor():
		transitioned.emit('jumping')


func exit() -> void:
	pass
