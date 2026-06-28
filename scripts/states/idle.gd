class_name Idle extends State

@export var run: State
@export var attack: State

func enter() -> void:
	player.play_animation("idle")
	
func exit() -> void:
	pass
	
func physics_process(_delta: float) -> State:
	if Input.is_action_just_pressed("attack"):
		return attack
	
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		player.last_direction = direction
		return run
	
	return null
