extends Node2D

signal release

onready var surface_sprite = $ParallaxBackground/SurfaceLayer/Sprite
onready var spawn_point = $ParallaxBackground/SpawnPoint
var tex_change_next: Texture

func world_start():
	if spawn_point:
		spawn_point.start()
	
func get_spawn_position() -> Vector2:
	return $ParallaxBackground/SpawnPoint.position

func _physics_process(delta):
	surface_sprite.region_rect.position.y -= delta * 100

func change_surface_texture(tex: Texture):
	$AnimationPlayer.play("surface_vanish")
	tex_change_next = tex

func _on_StageNodesHandler_change_surface(tex):
	change_surface_texture(tex)


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"surface_vanish":
			if tex_change_next: surface_sprite.texture = tex_change_next
			tex_change_next = null
			$AnimationPlayer.play("surface_appear")


func _on_SpawnPoint_release():
	emit_signal("release")


func _on_StageNodesHandler_change_spawn_texture(tex):
	if spawn_point: spawn_point.change_texture(tex)
