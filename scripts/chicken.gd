extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var rest_timer: Timer = $RestTimer
@onready var hitbox: Area2D = $Hitbox

const SPEED: float = 200.0
const JUMP_VELOCITY: float = -400.0
var direction: int = 0

var attack_mode: bool = true
var is_in_sight: bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if direction and attack_mode:
		velocity.x = direction * SPEED
		animated_sprite_2d.animation = "run"
		animated_sprite_2d.flip_h = direction > 0
	else:
		velocity.x = move_toward(velocity.x, 0, 5)
		animated_sprite_2d.animation = "idle"

	move_and_slide()
	
	for body in $Hitbox.get_overlapping_bodies():
		if body.is_in_group("player") and attack_mode:
			rest_timer.start()
			attack_mode = false
			var knockback_direction = sign(body.position.x - position.x)
			body.take_damage.call_deferred(knockback_direction)


func _on_rest_timer_timeout() -> void:
	attack_mode = true


func _on_attack_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		direction = sign(body.position.x - position.x)
		is_in_sight = true


func _on_attack_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		direction = 0
		is_in_sight = false
