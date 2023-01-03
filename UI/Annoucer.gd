extends Control

func announce(text):
	if not $AnimationPlayer.is_playing():
		$Label.text = text
		$AnimationPlayer.play("fall")
