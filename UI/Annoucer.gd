extends Control

export(Array, String) var message_queue = []

func say_next(text):
	message_queue.append(text)

func announce(text):
	if not $AnimationPlayer.is_playing():
		$Label.text = text
		$AnimationPlayer.play("fall")
	else:
		say_next(text)


func _on_Timer_timeout():
	if not message_queue.empty():
		announce(message_queue.pop_front())


func _on_AnimationPlayer_animation_finished(_anim_name):
	$Timer.start()
