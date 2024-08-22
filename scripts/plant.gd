extends CharacterBody2D

@export var direction: int = 1
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite_2d: Sprite2D = $Sprite2D

const Bullet = preload("res://scenes/bullet.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const BULLET_SPEED = 400

var is_in_shooting_area = false

func _physics_process(delta: float) -> void:
	update_animation_parameters()
	sprite_2d.flip_h = direction > 0
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func update_animation_parameters():
	if is_in_shooting_area:
		animation_tree['parameters/conditions/is_attacking'] = true
		animation_tree['parameters/conditions/is_idle'] = false
	else:
		animation_tree['parameters/conditions/is_attacking'] = false
		animation_tree['parameters/conditions/is_idle'] = true

func shoot():
	var bullet = Bullet.instantiate()
	bullet.position.x = sprite_2d.position.x + 24 * direction
	bullet.position.y = sprite_2d.position.y
	bullet.direction = direction
	add_child(bullet)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_in_shooting_area = true
		direction = sign(body.position.x - position.x)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_in_shooting_area = false
