extends Node

var BSOD: PackedScene = preload("res://UI/BlueScreenOfDeath.tscn")

func die(title: String, desc: String):
	var _err = get_tree().change_scene_to(BSOD)
	yield(get_tree().current_scene, "tree_exited")
	yield(get_tree(), "idle_frame")
	get_tree().current_scene.setBSOD(title, desc)
