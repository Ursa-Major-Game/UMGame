extends Sprite

signal blob_ready
signal blob_arrived

export (Vector2) var target
export (float, 0.01, 0.09) var speed = 0.05

func _ready():
	$AnimationPlayer.play("enter_tree")

func _physics_process(delta):
	if target:
		position = position.linear_interpolate(target, speed)

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("blob_ready")

func vanish():
	$AnimationPlayer.play("vanish")