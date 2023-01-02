extends SpaceObjectBody
class_name Ship

var bomb = preload("res://Gameplay/Items/Bomb.tscn")

export (float, 0.0, 0.2) var acceleration = 0.1
export (PackedScene) var Primary
export (Color) var PrimaryModulate = Color.white
export (PackedScene) var Secondary
export (Color) var SecondaryModulate = Color.white
export (float, 0.1, 2.0) var PrimaryScale = 1.0
export (float, 0.1, 2.0) var SecondaryScale = 1.0
export (GDScript) var AIScript

var PW_instance : Weapon
var SW_instance : Weapon
var AI_instance : AI

func destroy(remove = true):
	call_deferred("set_contact_monitor", false)
	var coll_info = {}
	coll_info.layer = collision_layer
	coll_info.mask = collision_mask
	collision_layer = 0
	collision_mask = 0
	$Sprite.visible = false
	var B = bomb.instance()
	get_tree().get_root().add_child(B)
	B.global_position = global_position
	yield(B, "child_exiting_tree")
	if remove: queue_free()

func _ready():
	if AIScript:
		AI_instance = AIScript.new()
		add_child(AI_instance)
		AI_instance.connect("fire_all", self, "fire_all")
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
	if PW_instance: 
		var c = {}
		c.remove_mask = collision_layer
		PW_instance.fire_ammo(get_tree().root, PrimaryModulate, c)
	
func fire_secondary():
	if SW_instance: 
		var c = {}
		c.remove_mask = collision_layer
		SW_instance.fire_ammo(get_tree().root, SecondaryModulate, c)

func fire_all():
	fire_primary()
	fire_secondary()


func _on_Ship_body_entered(body):
	if body is Ammo:
		destroy()
