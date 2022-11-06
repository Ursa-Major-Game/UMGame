extends SpaceObjectBody
class_name Asteroid

var sprite_scale = Vector2.ONE setget set_sprite_scale
var rotation_speed = rand_range(0.1, 2)

func set_sprite_scale(s: float):
	sprite_scale = Vector2(s, s)
	$Sprite.scale = sprite_scale
	$CollisionShape2D.scale *= sprite_scale/0.2

func _ready():
	dir = Vector2.ONE.rotated(rand_range(0, PI/2))

func _physics_process(delta):
	pass
	#velocity = dir * delta * max_speed
	#rotation += rotation_speed * delta
