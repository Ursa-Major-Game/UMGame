extends SpaceObjectKinematic
class_name Ammo

export (int) var ammo_speed = 500
export (int) var damage = 10

func _physics_process(delta):
	velocity = dir.normalized() * delta * ammo_speed
	rotation = dir.angle() + PI/2
	var coll = move_and_collide(velocity, false)

func destroy():
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	destroy()
