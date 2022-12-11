extends CanvasLayer
signal start_game(level)
signal paused
signal ui_displayed

var ui_input = {
	"down" : 1,
	"up" : -1,
}

onready var buttons_vbox = $MainMenuUI/HBoxContainer/VBoxContainer

export (int) var selection = 0 setget set_selection

var selection_blob: PackedScene = preload("res://UI/SelectionBlob.tscn")
var selection_blob_instance

func _ready():
	$AnimationPlayer.play("ui_start")
	yield($AnimationPlayer, "animation_finished")
	var pos = buttons_vbox.get_child(selection).rect_global_position + Vector2.DOWN * 24 + Vector2.LEFT * 28
	selection_blob_instance = selection_blob.instance()
	selection_blob_instance.modulate.a = 0
	add_child(selection_blob_instance)
	selection_blob_instance.position = pos
	emit_signal("ui_displayed")

func set_selection(i: int):
	var max_val = buttons_vbox.get_child_count() - 1
	if i > max_val: i = 0
	elif i < 0: i = max_val
	var pos = buttons_vbox.get_child(i).rect_global_position + Vector2.DOWN * 24 + Vector2.LEFT * 28
	selection = i
	selection_blob_instance.target = pos

func trigger_selected_button():
	var b: Button = buttons_vbox.get_child(selection)
	var s = b.get_signal_connection_list("pressed")[0]
	call_deferred(s.method)

func _on_StartButton_pressed():
	emit_signal("start_game")


func _on_BossesButton_pressed():
	set_selection(1)


func _on_OptionsButton_pressed():
	set_selection(2)


func _on_QuitButton_pressed():
	get_tree().quit()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		trigger_selected_button()
	for i in ui_input:
		if Input.is_action_just_pressed("ui_%s" % [i]):
			set_selection(selection+ui_input[i])

func vanish():
	$AnimationPlayer.play("vanish")
	$Background.open_view()
	selection_blob_instance.vanish()
	yield($AnimationPlayer, "animation_finished")
	$MainMenuUI.hide()
	set_process(false)
