extends State

@onready var player: Player = owner
@export var animation_name: String

func enter(_prev_state_name: String, data: Dictionary = {}) -> void:
	player.velocity.y = data.get('jump_speed') if data.get('jump_speed') else player.JUMP_VELOCITY
	player.jump_sound.play()
	if animation_name:
		player.animation_player.play(animation_name)

func update(_delta: float) -> void:
	player.direction = Input.get_axis("move_left", "move_right")
	if not player.is_on_floor() and player.velocity.y > 0:
		transitioned.emit("falling")


func exit() -> void:
	pass
