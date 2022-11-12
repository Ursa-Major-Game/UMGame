extends Node2D
class_name Weapon

export (PackedScene) var AmmoType
export (float, 0.1, 2) var AmmoScale = 1.0
export (float) var AmmoSpeed = 100.0
export (int, 1, 50) var RateOfFire = 10 # per seconds

var _AInstance : Ammo
onready var _Muzzle := $Muzzle

var _can_fire := true

func _ready():
	assert(AmmoType)
	$Timer.wait_time = 1/RateOfFire

func make_ammo() -> Ammo:
	return  AmmoType.instance()

func fire_ammo(N: Object = get_tree()) -> void:
	if not _can_fire: return
	
	var A = make_ammo()
	N.add_child(A)
	A.dir = Vector2.UP
	A.global_position = _Muzzle.global_position
	A.scale = Vector2(AmmoScale, AmmoScale)
	
	_can_fire = false
	$Timer.start()


func _on_Timer_timeout():
	_can_fire = true
