extends AI

signal fire_all

func _physics_process(delta):
	yield(get_tree().create_timer(1.5), "timeout")
	emit_signal("fire_all")
