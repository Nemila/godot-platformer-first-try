extends State

@onready var player: Player = owner
@export var damage_timer: Timer = null
@export var animation_name: String

func enter(_prev_state_name: String, data: Dictionary = {}) -> void:
	player.direction = 0
	player.life -= data.get('damage') if data.get('damage') else 1
	
	if player.life <= 0:
		Engine.time_scale = 0.5
		player.collision_shape_2d.disabled = true
		player.death_timer.start()
	
	if animation_name:
		player.animation_player.play(animation_name)
	
	if not damage_timer.timeout.is_connected(_on_damage_timer_timeout):
		damage_timer.timeout.connect(_on_damage_timer_timeout)
	
	if !damage_timer:
		print("No damage timer found")
		return
	
	if !data.get('knockback_dir'):
		print('knockback_dir not found')
		return
	
	damage_timer.start()
	player.velocity.y = player.JUMP_VELOCITY
	player.velocity.x = 300 * data.get('knockback_dir')


func update(_delta: float) -> void:
	if damage_timer.is_stopped():
		damage_timer.start()


func exit() -> void:
	pass


func _on_damage_timer_timeout():
	transitioned.emit('falling')
