tool
extends HBoxContainer

export (String) var Title setget set_title

func set_title(title: String):
	Title = title
	$Label.text = Title
