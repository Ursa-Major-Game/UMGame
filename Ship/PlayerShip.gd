extends Ship
class_name PlayerShip

var input_movement = {
	"down" : Vector2.DOWN,
	"up" : Vector2.UP,
	"left" : Vector2.LEFT,
	"right" : Vector2.RIGHT
}

var actions = {
	"primary_weapon" : "fire_primary",
	"secondary_weapon" : "fire_secondary"
}

func _physics_process(delta):
	dir = Vector2.ZERO
	for i in input_movement:
		var m = "ui_%s" % [i]
		if Input.is_action_pressed(m):
			dir += input_movement[i]
	dir = dir.normalized()
	velocity = lerp(velocity, dir * max_speed * delta, acceleration)
	position += velocity
	global_position.x = clamp(global_position.x, 0, Globals.game_screen_width)
	global_position.y = clamp(global_position.y, 0, Globals.game_screen_height)
	var roll = lerp(dir.x, dir.x * 25, 0.2)
	var pitch = lerp(dir.y, dir.y * 25, 0.2)
	$Sprite.material.set_shader_param("x_rot", roll)
	$Sprite.material.set_shader_param("y_rot", pitch)
	
	for a in actions:
		if Input.is_action_pressed(a): call(actions[a])
