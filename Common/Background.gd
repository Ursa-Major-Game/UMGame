extends Node2D

signal opened
signal closed

func open_view():
	$AnimationPlayer.play("OpenView")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("opened")
	
func close_view():
	$AnimationPlayer.play("RESET")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("closed")
