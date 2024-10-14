extends State

@onready var player: Player = owner
@export var animation_name: String
@export var coyote_timer: Timer
var can_jump: bool = false

func enter(prev_state_name: String, _data: Dictionary = {}) -> void:
	var prev_state: State = player.state_machine.states.get(prev_state_name.to_lower())
	
	if not prev_state:
		print(prev_state_name + " not found in states")
		return
	
	if not coyote_timer:
		print('Coyote timer not defined')
		return
	
	if not coyote_timer.timeout.is_connected(_on_coyete_timer_timeout):
		coyote_timer.timeout.connect(_on_coyete_timer_timeout)
	
	if prev_state.name.to_lower() == 'running':
		can_jump = true
		coyote_timer.start()
	
	if animation_name:
		player.animation_player.play(animation_name)


func update(_delta: float) -> void:
	player.direction = Input.get_axis("move_left", "move_right")
	
	if player.is_on_floor():
		transitioned.emit('idle')
	
	if can_jump and Input.is_action_pressed("jump"):
		can_jump = false
		transitioned.emit('jumping')


func exit() -> void:
	pass


func _on_coyete_timer_timeout() -> void:
	can_jump = false
