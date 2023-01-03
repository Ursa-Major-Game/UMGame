extends CanvasLayer
signal start_game(level)
signal ui_displayed

var ui_input = {
	"down" : 1,
	"up" : -1,
}

onready var buttons_vbox = $MainMenuUI/HBoxContainer/VBoxContainer

export (int) var selection = 0 setget set_selection

var selection_blob: PackedScene = preload("res://UI/SelectionBlob.tscn")
var selection_blob_instance

func enable_all_buttons(enable: bool = true):
	for c in $MainMenuUI/HBoxContainer/VBoxContainer.get_children():
		c.disabled = not enable

func _ready():
	$AnimationPlayer.play("ui_start")
	yield($AnimationPlayer, "animation_finished")
	var pos = buttons_vbox.get_child(selection).rect_global_position + Vector2.DOWN * 24 + Vector2.LEFT * 28
	selection_blob_instance = selection_blob.instance()
	add_child(selection_blob_instance)
	selection_blob_instance.position = pos
	emit_signal("ui_displayed")
	enable_all_buttons()

func set_selection(i: int):
	var max_val = buttons_vbox.get_child_count() - 1
	if i > max_val: i = 0
	elif i < 0: i = max_val
	var pos = buttons_vbox.get_child(i).rect_global_position + Vector2.DOWN * 24 + Vector2.LEFT * 28
	selection = i
	selection_blob_instance.target = pos

func trigger_selected_button():
	var b: Button = buttons_vbox.get_child(selection)
	if b.disabled: return
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
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		trigger_selected_button()
	for i in ui_input:
		if Input.is_action_just_pressed("ui_%s" % [i]):
			set_selection(selection+ui_input[i])

func vanish():
	$AnimationPlayer.play("vanish")
	selection_blob_instance.vanish()
	yield($AnimationPlayer, "animation_finished")
	$MainMenuUI.hide()
	set_process(false)

func reappear():
	$Background.close_view()
	$AnimationPlayer.play("vanish", -1, -1, true)
	yield($AnimationPlayer, "animation_finished")
	$MainMenuUI.modulate.a = 1.0
	$MainMenuUI.show()
	emit_signal("ui_displayed")
	set_process(true)
	selection_blob_instance.appear()
