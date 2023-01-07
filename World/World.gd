extends Node2D

onready var surface_sprite = $ParallaxBackground/SurfaceLayer/Sprite

func _physics_process(delta):
	surface_sprite.region_rect.position.y -= delta * 100
