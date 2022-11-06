extends Node2D
class_name Ammo

var dir: Vector2
var velocity : Vector2
var acceleration : float
var max_speed : float

func _physics_process(delta):
	velocity = dir.normalized() * delta * max_speed
