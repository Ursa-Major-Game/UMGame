extends AI

signal fire_all

onready var Ray = $RayCast2D
var player: PlayerShip

func _physics_process(_delta):
	if Ray.is_colliding():
		var c = Ray.get_collider()
		if c is PlayerShip:
			player = c
	
	if player:
		var to = host.global_position.direction_to(player.global_position).angle() + PI/2
		host.rotation = lerp_angle(host.rotation, to, 0.1)


func _on_Timer_timeout():
	emit_signal("fire_all")
