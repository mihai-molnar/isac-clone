class_name Run extends State

@export var idle: State
@export var dodge: State
@export var attack: State
var speed: float = 200.0

func enter() -> void:
	pass
	
func exit() -> void:
	player.velocity = Vector2.ZERO
	
func physics_process(_delta: float) -> State:
	if Input.is_action_just_pressed("dodge"):
		return dodge
		
	if Input.is_action_just_pressed("attack"):
		return attack
	
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		player.last_direction = direction
		player.play_animation("run")
		player.velocity = player.last_direction * speed
	else :
		return idle
		
	return null
