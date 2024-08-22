extends CharacterBody2D

signal death

@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var death_timer: Timer = $DeathTimer
@onready var hud: Control = $HUD

const SPEED: float = 200.0
const JUMP_VELOCITY: float = -450.0
const MAX_GRAVITY: float = 460.0

var direction: float = 1.0
var last_direction: float = direction
var sliding_strength: float = 10.0
var life: int = 3

var can_pick_up: bool = true
var controls_enabled: bool = true
var can_take_damage: bool = true

func _physics_process(delta: float) -> void:
	if not is_on_floor() and velocity.y < MAX_GRAVITY:
		velocity.y += get_gravity().y * delta
	
	if controls_enabled and Input.is_action_pressed("jump") and is_on_floor():
		jump_sound.play()
		velocity.y = JUMP_VELOCITY
	
	if controls_enabled:
		direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		last_direction = direction
		velocity.x = SPEED * direction
		animated_sprite_2d.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, sliding_strength)
	
	if not is_on_floor():
		if not can_take_damage:
			animated_sprite_2d.play("hit")
		else:
			animated_sprite_2d.animation = "fall" if velocity.y > 0 else "jump"
	else:
		animated_sprite_2d.animation = "run" if direction else "idle"
	
	move_and_slide()


func take_damage(knockback_direction: int, damage: int = 1) -> void:
	if not can_take_damage: return
	
	invincibility_timer.start()
	can_take_damage = false
	controls_enabled = false
	can_pick_up = false
	
	# Stop current movement then knockback
	direction = 0 
	velocity.y = -400
	velocity.x = 300 * knockback_direction
	
	life -= damage
	if life <= 0:
		death.emit()


func _on_invincibility_timer_timeout() -> void:
	can_take_damage = true
	controls_enabled = true
	can_pick_up = true


func _on_death() -> void:
	Engine.time_scale = 0.5
	collision_shape_2d.queue_free()
	hud.queue_free()
	death_timer.start()


func _on_death_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
