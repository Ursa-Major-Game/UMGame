extends Node

var BSOD: PackedScene = preload("res://UI/BlueScreenOfDeath.tscn")

var game_screen_width = 1280
var game_screen_height = 720

func die(title: String, desc: String):
	get_tree().change_scene_to(BSOD)
	yield(get_tree().current_scene, "tree_exited")
	yield(get_tree(), "idle_frame")
	get_tree().current_scene.setBSOD(title, desc)
