extends Control

signal resume_game

var selection_blob: PackedScene = preload("res://UI/SelectionBlob.tscn")
var selection_blob_instance

var selection := 0

func _ready():
	visible = false
