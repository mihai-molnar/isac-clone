class_name Dodge extends State

@export var run: State
@export var attack: State
var speed: float = 800.0
@onready var dodge_timer: Timer = $"../../Timers/DodgeTimer"
@onready var trail: AfterimageTrail = $"../../AfterimageTrail"

func enter() -> void:
	dodge_timer.start()
	player.velocity = player.last_direction * speed
	trail.start()

func exit() -> void:
	trail.stop()
	
func physics_process(_delta: float) -> State:
	if Input.is_action_just_pressed("attack"):
		return attack
	if dodge_timer.time_left <= 0:
		return run
	return null
