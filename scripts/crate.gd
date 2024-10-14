extends RigidBody2D

const VERTICAL_SPEED: float = -400.0
const HORIZONTAL_SPEED: float = 450.0

enum States {PICKED_UP, DROPPED}
var current_state: States = States.DROPPED: set = change_state
var player_in_range: bool = false

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hitbox: Area2D = $Hitbox

@onready var player: Player = get_tree().get_first_node_in_group('player')

func _physics_process(_delta: float) -> void:
	if current_state == States.PICKED_UP:
		global_position.x = player.global_position.x + 24 * player.last_direction
		global_position.y = player.global_position.y - 18
		if not player.is_holding_crate:
			current_state = States.DROPPED
	elif current_state == States.DROPPED:
		pass
	
	
	if current_state == States.PICKED_UP and Input.is_action_just_pressed('action') and hitbox.get_overlapping_bodies().size() <= 0 and player.is_holding_crate:
		current_state = States.DROPPED
	elif current_state == States.DROPPED and Input.is_action_just_pressed('action') and player_in_range and not player.is_holding_crate:
		current_state = States.PICKED_UP


func change_state(new_state: States) -> void:
	var old_state : States = current_state
	current_state = new_state
	
	if old_state == new_state:
		print("Box is already in " + States.find_key(new_state) + " state")
		return
	
	if new_state == States.PICKED_UP:
		print("You are picking it up")
		collision_shape_2d.disabled = true
		player.is_holding_crate = true
		rotation = 0
		gravity_scale = 0
	elif new_state == States.DROPPED:
		print("You are dropping it down")
		gravity_scale = 1
		collision_shape_2d.disabled = false
		player.is_holding_crate = false
		linear_velocity.y = -450
		linear_velocity.x = 300 * player.last_direction


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
