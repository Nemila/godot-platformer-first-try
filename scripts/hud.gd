extends Control

@onready var action_button: TextureButton = $ActionButton

func _process(_delta: float) -> void:
	action_button.button_pressed = true if Input.is_action_pressed("action") else false
