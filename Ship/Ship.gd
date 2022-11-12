extends SpaceObjectKinematic
class_name Ship

export (float, 0.0, 0.2) var acceleration = 0.1
export (PackedScene) var Primary
export (PackedScene) var Secondary

var PW_instance : Weapon
var SW_instance : Weapon

func _ready():
	show()
	if Primary:
		PW_instance = Primary.instance()
		$PrimaryAnchor.add_child(PW_instance)
	if Secondary:
		SW_instance = Secondary.instance()
		$SecondaryAnchor.add_child(SW_instance)

func hide():
	$Sprite.modulate.a = 0
	
func show():
	$AnimationPlayer.play("apparition")

func fire_primary():
	if PW_instance: PW_instance.fire_ammo()
	
func fire_secondary():
	if SW_instance: SW_instance.fire_ammo()
