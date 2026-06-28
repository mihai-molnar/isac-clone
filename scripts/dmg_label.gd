class_name DmgLabel extends Label

var dmg: float

func _ready() -> void:
	animate_label(dmg)
	
func _physics_process(_delta: float) -> void:
	pass
	
func setup(damage: float):
	dmg = damage
	
func animate_label(val: float) -> void:
	position = Vector2.ZERO
	text = str(int(val))
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(0, -150), 0.3)
	tween.tween_property(self, "visible", false, 0.6)
