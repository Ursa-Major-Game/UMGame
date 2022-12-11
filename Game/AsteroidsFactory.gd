extends Node2D

export (PackedScene) var asteroid = preload("res://Asteroid/Asteroid.tscn")
export (float, 0, 10) var salvo_frequency = 3 #per minutes
export (float, 0, 10) var salvo_duration = 1 #seconds
export (int, 0, 10) var asteroids_per_salvo = 5

func _ready():
	$SalvoTimer.wait_time = salvo_duration
	$Timer.wait_time = 60/salvo_frequency

func produce_asteroid(pos: Vector2 = Vector2.ZERO) -> Asteroid:
	var asteroid_instance = asteroid.instance()
	$Pool.add_child(asteroid_instance)
	asteroid_instance.position = pos
	return asteroid_instance

func produce_asteroid_dir(pos: Vector2 = Vector2.ZERO, _dir: Vector2 = Vector2.DOWN) -> Asteroid:
	var asteroid_instance = produce_asteroid(pos)
	asteroid_instance.dir = _dir.rotated(rand_range(0, PI/4))
	asteroid_instance.sprite_scale = rand_range(0.05, 0.2)
	asteroid_instance.max_speed = rand_range(50, 150)
	return asteroid_instance

func _on_Timer_timeout():
	var A = produce_asteroid_dir(Vector2(randi() % 720, -80))
	$Timer.wait_time += rand_range(-0.5, 0.5)
