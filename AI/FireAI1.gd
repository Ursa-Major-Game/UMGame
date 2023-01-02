extends AI

signal fire_all

func _on_Timer_timeout():
	emit_signal("fire_all")
