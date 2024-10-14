class_name State extends Node

@warning_ignore("unused_signal")
signal transitioned

func enter(_prev_state_name: String, _data: Dictionary = {}) -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass
