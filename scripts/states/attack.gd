class_name Attack extends State

@export var idle: State
@export var run: State
var dmg: float = 20

func enter() -> void:
	player.play_animation("attack")
	if player.last_direction.y > 0:
		player.attack_area.position.y += 20
		player.attack_area.scale = Vector2(1.4, 1.0)
	elif player.last_direction.y < 0:
		player.attack_area.position.y -= 20
		player.attack_area.scale = Vector2(1.4, 1.0)
	elif player.last_direction.x > 0:
		player.attack_area.position.x += 20
		player.attack_area.position.y += 5
		player.attack_area.scale = Vector2(1.4, 1.2)
	elif player.last_direction.x < 0:
		player.attack_area.position.x -= 20
		player.attack_area.position.y += 5
		player.attack_area.scale = Vector2(1.4, 1.2)
	
func exit() -> void:
	player.attack_area.monitoring = false
	player.attack_area.position = Vector2.ZERO
	player.attack_area.scale = Vector2(1.0, 1.0)
	
func physics_process(_delta: float) -> State:
	if player.animated_sprite_2d.frame == 1:
		player.attack_area.monitoring = true
		
	var direction = Input.get_vector("left", "right", "up", "down")
	if !player.animated_sprite_2d.is_playing():
		if direction:
			return run
		return idle
	return null


func _on_attack_area_body_entered(body: Enemy) -> void:
	body.take_damage(dmg)
