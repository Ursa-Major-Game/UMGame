extends SpaceObjectKinematic
class_name Ammo

export (int) var ammo_speed = 500

var active : bool = false
var on_screen : bool = false

func _physics_process(delta):
	on_screen = $VisibilityNotifier2D.is_on_screen()
	if on_screen: $Timer.start()
	velocity = dir.normalized() * delta * ammo_speed
	rotation = dir.angle() + PI/2
	var coll = move_and_collide(velocity)
	if coll: destroy()
	
	if active: #and not already destroyed
		if not on_screen or coll : destroy()

func destroy():
	queue_free()


func _on_Timer_timeout():
	active = true
