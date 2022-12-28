extends Node2D

func _physics_process(delta):
	$Ship001.rotate(0.1*delta)

