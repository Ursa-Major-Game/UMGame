extends SpaceObject
class_name Ship

export (float, 0.0, 0.2) var acceleration = 0.1
export (Array, PackedScene) var weapons = []

var w_instances = []

func _ready():
	show()
	for w in weapons: w_instances.append(w.instance())

func hide():
	$Sprite.modulate.a = 0
	
func show():
	$AnimationPlayer.play("apparition")
	
func shoot(id: int):
	w_instances.primary.shoot()