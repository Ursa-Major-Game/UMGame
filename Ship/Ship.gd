extends SpaceObject
class_name Ship

export (float, 0.0, 0.2) var acceleration = 0.1
export (Array, PackedScene) var weapons = []

var w_instances = []
var w_current: int

func _ready():
	show()
	for w in weapons: w_instances.append(w.instance())
	if w_instances.size() > 0: w_current = 0

func hide():
	$Sprite.modulate.a = 0
	
func show():
	$AnimationPlayer.play("apparition")
	
func shoot(id: int):
	w_instances.primary.shoot()

func get_current_weapon () -> Weapon:
	return w_current and w_instances[w_current]
