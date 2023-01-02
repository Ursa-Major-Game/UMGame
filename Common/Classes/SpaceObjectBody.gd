extends RigidBody2D

class_name SpaceObjectBody

var dir : Vector2
var velocity : Vector2
export (int) var max_speed = 100
export (int) var object_friction = 1

func get_collision_layer_bits() -> Array:
	var layer_bits = []
	for l in 16:
		var bit_value = get_collision_layer_bit(l)
		if bit_value: layer_bits.append(l)
	return layer_bits

func get_collision_mask_bits() -> Array:
	var mask_bits = []
	for l in 16:
		var bit_value = get_collision_layer_bit(l)
		if bit_value: mask_bits.append(l)
	return mask_bits

func set_collision_layer(v: int):
	collision_layer = v
	
func set_collision_mask(v: int):
	collision_mask = v

func remove_mask(v: int):
	set_collision_mask_bit(v, false)

func add_mask(v: int):
	set_collision_mask_bit(v, true)
