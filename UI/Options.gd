extends Control

onready var LeftVBox = $VBoxContainer
onready var RightVBox = $SoundVBox

func activate():
	visible = true
	$VBoxContainer/FullscreenButton.pressed = OS.window_fullscreen

func toggle():
	if visible: visible = false
	else: activate()

func _on_FullscreenButton_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
	UserOptions.loaded_config.set_value("Screen", "fullscreen", button_pressed)
