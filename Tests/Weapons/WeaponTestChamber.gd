extends Node2D

var dir := Vector2.ZERO
var move_speed := 250

onready var weapon = $WeaponAnchor/LaserWeapon01

func _physics_process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_pressed("ui_left"):
		dir.x += -1
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_select"):
		weapon.fire_ammo(self)
	$WeaponAnchor.position += dir * delta * move_speed
	dir = Vector2.ZERO
