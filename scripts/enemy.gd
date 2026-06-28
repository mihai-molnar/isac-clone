class_name Enemy extends CharacterBody2D

var hp: float = 100
@onready var dmg_label: Label = $DmgLabel
var dmg_label_scene = preload("res://scenes/dmg_label.tscn")

func _ready() -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	if hp <= 0:
		die()
	
func take_damage(dmg: float) -> void:
	var label = dmg_label_scene.instantiate()
	label.setup(dmg)
	add_child(label)
	hp -= dmg
	

func die() -> void:
	queue_free()
