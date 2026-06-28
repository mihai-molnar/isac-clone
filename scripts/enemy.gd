class_name Enemy extends CharacterBody2D

var hp: float = 100

func _ready() -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	if hp <= 0:
		die()
	
func take_damage(dmg: float) -> void:
	hp -= dmg
	
func die() -> void:
	queue_free()
