extends RigidBody2D

var is_picked_up: bool = false
var is_colliding_with_player: bool = false
var is_colliding_with_bodies: bool = true

const VERTICAL_SPEED: float = -400.0
const HORIZONTAL_SPEED: float = 450.0

@onready var player: CharacterBody2D = %Player

func _process(_delta: float) -> void:
	var in_safe_zone: bool = $Area2D.get_overlapping_bodies().is_empty()
	if is_picked_up and Input.is_action_just_pressed("action") and in_safe_zone:
		drop()
	if player.can_pick_up and is_colliding_with_player and not is_picked_up and Input.is_action_just_pressed("action"):
		pick_up()
	if is_picked_up:
		position.x = player.position.x + player.last_direction * 24
		position.y = player.position.y

func pick_up():
	rotation = 0
	gravity_scale = 0
	is_picked_up = true
	player.can_pick_up = false
	$CollisionShape2D.disabled = true

func drop():
	gravity_scale = 1
	is_picked_up = false
	player.can_pick_up = true
	linear_velocity.y = VERTICAL_SPEED
	$CollisionShape2D.disabled = false
	linear_velocity.x = HORIZONTAL_SPEED * player.last_direction

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_colliding_with_player = true
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_colliding_with_player = false
	
