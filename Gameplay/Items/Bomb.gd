extends Node2D

func _ready():
	$AnimationPlayer.play("expand")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
