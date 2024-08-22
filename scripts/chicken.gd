extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var attack_mode = false
var is_in_sight_area = false
var direction: float = 0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.flip_h = direction > 0
	else:
		velocity.x = move_toward(velocity.x, 0, 5)
		$AnimatedSprite2D.animation = "idle"

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_in_sight_area = true
		direction = sign(%Player.position.x - position.x)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_in_sight_area = false
		direction = 0
		
