extends RigidBody2D

@onready var player: CharacterBody2D = %Player

signal dropped

var is_picked_up: bool = false
var colliding_with_player: bool = false
var direction: int = 0
var initial_position: Vector2

const VERTICAL_THROW_FORCE: float = -400.0
const HORIZONTAL_THROW_FORCE: float = 300.0

func _ready() -> void:
	initial_position = position

func _physics_process(_delta: float) -> void:
	print(is_picked_up)
	if is_picked_up:
		position.x = move_toward(position.x, player.position.x + 24 * player.last_direction, 5)
		position.y = move_toward(position.y, player.position.y + 10, 5)
		direction = player.last_direction
	
	if Input.is_action_just_pressed("action") and is_picked_up:
		is_picked_up = false
		$CollisionShape2D.set_deferred("disabled", false)
		$PickupZone/CollisionShape2D.set_deferred("disabled", false)
		
	if colliding_with_player and not is_picked_up and Input.is_action_just_pressed("action"):
		is_picked_up = true
		$CollisionShape2D.set_deferred("disabled", false)
		$PickupZone/CollisionShape2D.set_deferred("disabled", true)

func reset_position() -> void:
	$CollisionShape2D.set_deferred("disabled", false)
	$PickupZone/CollisionShape2D.set_deferred("disabled", false)
	is_picked_up = false
	colliding_with_player = false
	position = initial_position

func _on_pickup_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		colliding_with_player = true
func _on_pickup_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		colliding_with_player = false
