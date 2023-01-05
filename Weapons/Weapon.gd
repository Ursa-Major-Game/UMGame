extends Node2D
class_name Weapon

export (PackedScene) var AmmoType
export (float, 0.1, 2) var AmmoScale = 1.0
export (float) var AmmoSpeed = 100.0
export (float, 1, 50) var RateOfFire = 10.0 # per seconds
export (int, 1, 5) var AmmoNumber = 1
export (float) var spacing_angle = 0.0
export (float, 0.0, 1.0) var rand_variation_ratio = 0.1

var _AInstance : Ammo
onready var _Muzzle := $Muzzle

var _can_fire := true

func _ready():
	if not AmmoType: ErrorHandler.die("No Ammo Type on weapon", "Node: " + self.name)
	$Timer.wait_time = 1/RateOfFire

func make_ammo() -> Ammo:
	return  AmmoType.instance()

func fire_ammo(N: Object = get_tree().root, tint: Color = Color.white, collisions : Dictionary = {}):
	if not _can_fire: return
	
	var c = 1
	for i in AmmoNumber:
		var A = make_ammo()
		N.add_child(A)
		A.modulate = tint
		A.dir = global_position.direction_to(_Muzzle.global_position)
		A.dir = A.dir.rotated(c * deg2rad(spacing_angle))
		A.dir = A.dir.rotated(min(randf(), rand_variation_ratio))
		A.global_position = _Muzzle.global_position
		A.scale = Vector2(AmmoScale, AmmoScale)
		if collisions.has("layer") : A.set_collision_layer(collisions.layer)
		if collisions.has("mask"): A.set_collision_mask(collisions.mask)
		if collisions.has("remove_mask"): A.remove_mask(collisions.remove_mask)
		if collisions.has("remove_mask_bits"):
			for mbit in collisions.remove_mask_bits:
				A.set_collision_mask_bit(mbit, false)
		c = c * (-1)
	
	_can_fire = false
	$Timer.start()


func _on_Timer_timeout():
	_can_fire = true
