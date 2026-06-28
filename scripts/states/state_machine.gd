class_name StateMachine extends Node

@export var player: Player
@export var initial_state: State

var current_state: State
var previous_state: State

func _ready() -> void:
	for c in get_children():
		if c is State:
			c.player = player
			
	if initial_state:
		current_state = initial_state
		
	current_state.enter.call_deferred()
	
func _physics_process(delta: float) -> void:				 
	var new_state: State = current_state.physics_process(delta)
	if new_state:
		current_state.exit()
		previous_state = current_state
		current_state = new_state
		current_state.enter()
