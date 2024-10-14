class_name StateMachine extends Node


@export var initial_state: State = null
var current_state: State = null
var states: Dictionary = {}


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_state_transitioned)
	
	await owner.ready
	
	if initial_state:
		initial_state.enter("")
		current_state = initial_state


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func _on_state_transitioned(new_state_name: String, data: Dictionary = {}) -> void:
	var new_state: State = states.get(new_state_name.to_lower())
	
	current_state.exit()
	var old_state = current_state
	
	if not new_state:
		print(new_state_name + " not found in state list")
		return
		
	new_state.enter(old_state.name, data)
	current_state = new_state
