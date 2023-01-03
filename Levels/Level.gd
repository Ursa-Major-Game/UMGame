extends Resource

class_name Level

export (String) var level_name = "untitled"
export (float) var appeance_time = 100.0
export (PackedScene) var level_data

func transfer_nodes_to(to: Node):
	var scene = level_data.instance()
	print("Loaded " + level_name + " : " + String(scene.get_children().size()) + " entities.")
	for c in scene.get_children():
		
		scene.remove_child(c)
		to.add_child(c)
		c.set_owner(to)
