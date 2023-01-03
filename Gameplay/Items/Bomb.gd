extends Area2D

func _ready():
	$AnimationPlayer.play("expand")

func _on_Bomb_body_entered(body):
	body.destroy()

func _on_Timer_timeout():
	pass # Replace with function body.

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
