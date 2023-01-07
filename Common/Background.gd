extends Node2D

signal opened
signal closed

func open_view():
	$AnimationPlayer.play("OpenView")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("opened")
	
func close_view():
	$AnimationPlayer.play("OpenView", -1, -1, true)
	yield($AnimationPlayer, "animation_finished")
	emit_signal("closed")

func get_limits_left() -> Vector2:
	return $LeftSide/LeftPosition2D.global_position

func get_limits_right() -> Vector2:
	return $RightSide/RightPosition2D.global_position

func _ready():
	$LeftSide/ColorRect.modulate.a = 0.0
	$RightSide/ColorRect2.modulate.a = 0.0
