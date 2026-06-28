class_name Player extends CharacterBody2D

var last_direction: Vector2 = Vector2.DOWN
@export var animated_sprite_2d: AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea

func _ready() -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	
	move_and_slide()
	
func play_animation(animation: String) -> void:
	var dir: String
	if last_direction.y > 0:
		dir = "_down"
	elif last_direction.y < 0:
		dir = "_up"
	elif last_direction.x > 0:
		dir = "_right"
	elif last_direction.x < 0:
		dir = "_left"
	if animation + dir != animated_sprite_2d.animation:
		animated_sprite_2d.play(animation + dir)
