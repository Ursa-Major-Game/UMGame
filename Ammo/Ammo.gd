extends SpaceObjectKinematic
class_name Ammo

export (int) var ammo_speed = 500

var vis_proc : bool = false

func _physics_process(delta):
	velocity = dir.normalized() * delta * ammo_speed
	rotation = dir.angle() + PI/2
	var coll = move_and_collide(velocity)
	
	if vis_proc: #and not already destroyed
		var on_screen = $VisibilityNotifier2D.is_on_screen()
		if not on_screen or coll : destroy()

func destroy():
	queue_free()


func _on_Timer_timeout():
	vis_proc = true
