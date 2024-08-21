extends Control

func _process(_delta: float) -> void:
	$Container/Label.text = "x " + str(%Control.score)
	
	if Input.is_action_pressed("action"):
		$ActionButton.button_pressed = true
	else:
		$ActionButton.button_pressed = false
