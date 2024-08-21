extends CharacterBody2D

@export var direction: int = 1

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const BULLET_SPEED = 400
const Bullet = preload("res://scenes/bullet.tscn")
var attack_mode = false
var is_in_shooting_area = false


func _ready() -> void:
	scale.x = -direction

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	
	if is_in_shooting_area and not attack_mode:
		attack_mode = true
		$AnimationPlayer.play("attack")

func shoot():
	var bullet = Bullet.instantiate()
	bullet.position = $Marker2D.position
	bullet.direction = direction
	add_child(bullet)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player_facing_direction = sign(%Player.position.x - position.x)
		if direction != player_facing_direction:
			direction = sign(%Player.position.x - position.x)
			print("Turn around")
			scale.x = -1
		attack_mode = true
		is_in_shooting_area = true
		$AnimationPlayer.play("attack")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_in_shooting_area = false

func _on_attack_timer_timeout() -> void:
	attack_mode = false
	$AnimationPlayer.play("idle")
