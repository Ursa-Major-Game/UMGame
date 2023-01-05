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
export (PackedScene) var AIScript
export (PackedScene) var PathModifier

var PW_instance : Weapon
var SW_instance : Weapon
var AI_instance : AI

var coll_info: Dictionary

var invincible = true
var active = false

func destroy(remove = true, no_bomb = true):
	var lbit = get_collision_layer_bits()[0]
	coll_info.layer = collision_layer
	coll_info.mask = collision_mask
	collision_layer = 8
	collision_mask = 8
	$Sprite.visible = false
	if no_bomb: 
		if remove: 
			queue_free()
			return
	var B = bomb.instance()
	B.set_collision_mask_bit(lbit, false)
	get_tree().get_root().call_deferred("add_child", B)
	B.global_position = global_position
	if remove: queue_free()

func _ready():
	if AIScript:
		AI_instance = AIScript.instance()
		add_child(AI_instance)
		var _err = AI_instance.connect("fire_all", self, "fire_all")
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
		c.remove_mask_bits = get_collision_layer_bits()
		PW_instance.fire_ammo(get_tree().root, PrimaryModulate, c)
	
func fire_secondary():
	if SW_instance: 
		var c = {}
		c.remove_mask_bits = get_collision_layer_bits()
		SW_instance.fire_ammo(get_tree().root, SecondaryModulate, c)

func fire_all():
	fire_primary()
	fire_secondary()


func _on_Ship_body_entered(body):
	if not active: return
	if not invincible: call_deferred("destroy")
	body.destroy()


func _on_InvincibleTimer_timeout():
	invincible = false


func _on_ActiveTimer_timeout():
	active = true


func _on_VisibilityNotifier2D_screen_entered():
	active = true


func _on_VisibilityNotifier2D_screen_exited():
	if active: destroy()
