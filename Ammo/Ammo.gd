extends SpaceObjectKinematic
class_name Ammo

export (int) var ammo_speed = 500

func _physics_process(delta):
	velocity = dir.normalized() * delta * ammo_speed
	global_position += velocity
	if global_position.y <= -50: queue_free()
