extends SpaceObjectBody
class_name Ship

export (float, 0.0, 0.2) var acceleration = 0.1
export (PackedScene) var Primary
export (PackedScene) var Secondary
export (float, 0.1, 2.0) var PrimaryScale = 1.0
export (float, 0.1, 2.0) var SecondaryScale = 1.0

var PW_instance : Weapon
var SW_instance : Weapon

func _ready():
	show()
	yield($AnimationPlayer,"animation_finished")
	if Primary:
		PW_instance = Primary.instance()
		$PrimaryAnchor.add_child(PW_instance)
		PW_instance.scale = Vector2(PrimaryScale, PrimaryScale)
	if Secondary:
		SW_instance = Secondary.instance()
		$SecondaryAnchor.add_child(SW_instance)
		SW_instance.scale = Vector2(SecondaryScale, SecondaryScale)

func hide():
	$Sprite.modulate.a = 0
	
func show():
	$AnimationPlayer.play("apparition")

func fire_primary():
	if PW_instance: PW_instance.fire_ammo()
	
func fire_secondary():
	if SW_instance: SW_instance.fire_ammo()

func fire_all():
	fire_primary()
	fire_secondary()
