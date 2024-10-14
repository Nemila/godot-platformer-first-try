class_name Player extends CharacterBody2D

const SPEED: float = 200.0
const JUMP_VELOCITY: float = -450.0
const MAX_GRAVITY: float = 460.0

var is_holding_crate: bool = false
var direction: float = 0.0
var last_direction: float = direction
var life := 3

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var death_timer: Timer = $DeathTimer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _physics_process(delta: float) -> void:
	if not is_on_floor() and velocity.y < MAX_GRAVITY:
		velocity.y += get_gravity().y * delta
	
	if direction:
		last_direction = direction
		velocity.x = direction * SPEED
		sprite_2d.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 3 * delta)
	
	move_and_slide()


func _on_death_timer_timeout() -> void:
	Engine.time_scale = 1
	collision_shape_2d.disabled = false
	get_tree().reload_current_scene()
