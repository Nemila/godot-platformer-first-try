extends Area2D
@onready var animation_tree: AnimationTree = $AnimationTree
var finished: bool = false
var next_scene_path: String

func _ready() -> void:
	var current_scene = get_tree().current_scene.scene_file_path
	var next_level = int(current_scene) + 1
	next_scene_path = "res://scenes/levels/level_" + str(next_level) + ".tscn"

func _process(_delta: float) -> void:
	finished = get_tree().get_nodes_in_group("apple").size() <= 0
	if finished:
		animation_tree['parameters/conditions/is_out'] = true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and finished:
		get_tree().change_scene_to_file.call_deferred(next_scene_path)
