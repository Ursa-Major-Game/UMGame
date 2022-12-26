extends Control

func setBSOD(title: String, desc: String):
	$VBoxContainer/TitleLabel.text = title
	$VBoxContainer/DescriptionLabel.text = desc


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_CopyErrButton_pressed():
	OS.clipboard = $VBoxContainer/DescriptionLabel.text
