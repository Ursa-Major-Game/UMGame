extends Node

signal set_health_bar(health)

var score: int = 0
export (int) var initial_lifes = 5

var health : int = 100 setget set_health
onready var lifes : int = initial_lifes

func reset():
	score = 0
	lifes = initial_lifes
	set_health(100)

func set_health(v: int):
	health = clamp(v, 0, 100)
	emit_signal("set_health_bar", health)
