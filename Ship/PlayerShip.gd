extends Ship
class_name PlayerShip

signal lifes_changed(lifes)
signal game_end

var input_movement = {
	"down" : Vector2.DOWN,
	"up" : Vector2.UP,
	"left" : Vector2.LEFT,
	"right" : Vector2.RIGHT
}

var actions = {
	"primary_weapon" : "fire_primary",
	"secondary_weapon" : "fire_secondary",
	"focus_mode": "focus_weapons",
	"all_weapons" : "fire_all"
}

var limits = {
	"left": Vector2(0, 0),
	"right" : Vector2(1280, 720)
}

export (bool) var toggle_focus = false
var focused = false
var input_inactive : bool = true

export (int, 50, 1000) var thrust

export (int, 0, 10) var max_lifes = 5
onready var lifes = max_lifes setget set_lifes

func set_lifes(l: int):
	lifes = clamp(l, 0, max_lifes)
	emit_signal("lifes_changed", lifes)
	if lifes == 0:
		emit_signal("game_end")
	
func set_shield(s: int):
	shield = clamp(s, 0, max_shield)
	emit_signal("shield_changed", shield)
	if shield == 0:
		set_lifes(lifes - 1)
		set_shield(max_shield)
		call_deferred("destroy")

func _ready():
	var _err = connect("shield_changed", GamePlayerInfo, "set_shield")
	var _err2 = connect("lifes_changed", GamePlayerInfo, "set_lifes")
	reset(true)

func focus_weapons():
	if not focused:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("focus_weapons")
			
func unfocus_weapons():
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play_backwards("focus_weapons")

func reset(reset_lifes :bool = false):
	$Sprite.visible = true
	set_shield(max_shield)
	if reset_lifes:
		set_lifes(max_lifes)
	
func destroy(_remove = false, _no_bomb = false):
	.destroy(_remove, _no_bomb)
	$AnimationPlayer.play("hit")
	can_fire = false
	$RespawnTimer.call_deferred("start")

func _integrate_forces(_state):
	if input_inactive : return
	dir = Vector2.ZERO
	for i in input_movement:
		var m = "move_%s" % [i]
		if Input.is_action_pressed(m):
			dir += input_movement[i]
	dir = dir.normalized()
	applied_force = (dir * thrust) * 2

func _physics_process(_delta):
	rotation = 0
	global_position.x = clamp(global_position.x, limits.left.x, limits.right.x)
	global_position.y = clamp(global_position.y, limits.left.y, limits.right.y)
	var pitch = lerp(dir.x, dir.x * 25, 0.3)
	var roll = lerp(dir.y, dir.y * -25, 0.3)
	$Sprite.material.set_shader_param("x_rot", roll)
	$Sprite.material.set_shader_param("y_rot", pitch)
	
	if input_inactive: return 
	for a in actions:
		if Input.is_action_pressed(a): call(actions[a])
	
	if not toggle_focus:
		if focused:
			if not Input.is_action_pressed("focus_mode"):
				unfocus_weapons()
	
	$CoreSprite.rotate(_delta)

func _on_RespawnTimer_timeout():
	reset()
	can_fire = true


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"focus_weapons": focused = not focused
