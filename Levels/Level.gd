extends Resource

class_name Level

export (String) var level_name = "untitled"
export (float) var appeance_time = 100.0
export (PackedScene) var level_data
export (String) var text
export (Vector2) var v_speed

func load_data_from_name():
	level_data = load("res://Levels/StageNodes/" + level_name + ".tscn")

func transfer_nodes_to(to: Node):
	var scene = level_data.instance()
	print("Loaded " + level_name + " : " + String(scene.get_children().size()) + " entities.")
	for c in scene.get_children():
		scene.remove_child(c)
		to.add_child(c)
		c.set_owner(to)
		if v_speed: c.linear_velocity = Vector2(0, v_speed)
