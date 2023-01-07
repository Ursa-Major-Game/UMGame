extends RigidBody2D

signal release

func start():
	$Timer.start()

func _physics_process(delta):
	$Sprite.rotate(delta)
	$Label.text = String(int($Timer.time_left))

func _on_Timer_timeout():
	emit_signal("release")
	$Label.visible = false


func _on_SpawnPoint_release():
	linear_velocity = Vector2.DOWN * 300


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func change_texture(tex: Texture):
	$Sprite.texture = tex
