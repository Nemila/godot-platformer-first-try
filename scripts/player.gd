extends CharacterBody2D

const SPEED: float = 200.0
const JUMP_VELOCITY: float = -450.0
const MAX_GRAVITY: float = 460.0

var last_direction: float = 1.0
var direction: float = 0.0
var can_pick_up: bool = true
var is_knocked_back = false

var knockback_await_time = 20
var knockback_timer = knockback_await_time
 
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound

func _physics_process(delta: float) -> void:
	if not is_on_floor() and velocity.y < MAX_GRAVITY:
		velocity.y += get_gravity().y * delta
	
	if Input.is_action_pressed("jump") and is_on_floor():
		jump_sound.play()
		velocity.y = JUMP_VELOCITY
	
	direction = Input.get_axis("move_left", "move_right")
	
	if direction and not is_knocked_back:
		last_direction = direction
		velocity.x = SPEED * direction
		$AnimatedSprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, 10)
	
	if not is_on_floor():
		$AnimatedSprite2D.animation = "fall" if velocity.y > 0 else "jump"
	else:
		$AnimatedSprite2D.animation = "run" if direction else "idle"

	knockback_timer -= 1
	
	if is_on_floor() and knockback_timer <= 0 and is_knocked_back:
		knockback_timer = knockback_await_time
		is_knocked_back = false
	
	move_and_slide()

func knockback(dir: int) -> void:
	knockback_timer = knockback_await_time
	velocity.y = -400
	velocity.x = 300 * dir
	is_knocked_back = true

func kill_player() -> void:
	Engine.time_scale = 0.5
	$HUD.queue_free()
	$CollisionShape2D.queue_free()
	$DeathTimer.start()

func _on_death_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
