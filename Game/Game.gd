extends Node2D

export (PackedScene) var PlayerShip
export (bool) var dbg_straight_to_game = false

var game_input = {
	"pause": "pause_game",
	"debug_toggle": "debug_toggle",
	"debug_unzoom_cam" : "unzoom",
	"debug_reset_zoom": "reset_zoom"
}

var can_pause:= false

var PlayerShipInstance: PlayerShip
onready var SpawnPoint: Position2D = $SpawnPosition2D

func unzoom():
	$Camera2D.zoom = Vector2(2, 2)

func reset_zoom():
	$Camera2D.zoom = Vector2.ONE

func add_player_ship():
	if PlayerShipInstance: return
	PlayerShipInstance = PlayerShip.instance()
	PlayerShipInstance.get_node("Sprite").modulate.a = 0
	if PlayerShipInstance:
		SpawnPoint.position = $World.get_spawn_position()
		SpawnPoint.add_child(PlayerShipInstance)
		PlayerShipInstance.limits.left = $UILayer/Background.get_limits_left()
		PlayerShipInstance.limits.right = $UILayer/Background.get_limits_right()
		PlayerShipInstance.linear_velocity = Vector2.DOWN * 150
		var _err = PlayerShipInstance.connect("game_end", self, "end_game")

func start_game():
	var resuming = get_tree().paused
	$UILayer.vanish()
	$UILayer/Background.open_view()
	yield($UILayer/Background, "opened")
	if resuming:
		get_tree().paused = false
	can_pause = true
	$StageNodesHandler.start(resuming)
	$World.world_start()
	$AnimationPlayer.play("fade-in")
	#$MusicPlayer.play()

func pause_game():
	if not can_pause: return
	get_tree().paused = true
	$UILayer.reappear()
	$UILayer/MainMenuUI/HBoxContainer/VBoxContainer/StartButton.text = "Resume"
	yield($UILayer, "ui_displayed")
	can_pause = false

func end_game():
	var _err = get_tree().change_scene("res://Game/Game.tscn")

func _ready():
	UserOptions.connect("finished", self, "_on_UserOptions_finished")
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	yield($UILayer, "ui_displayed")
	if dbg_straight_to_game: start_game()
	
func debug_toggle():
	$UIDebugLayer.visible = not $UIDebugLayer.visible

func _process(_delta):
	for gi in game_input.keys():
		if Input.is_action_just_pressed(gi):
			call(game_input[gi])
	
func _on_UILayer_start_game():
	start_game()


func _on_StageNodesHandler_Progressed(seconds):
	$UIDebugLayer/VBoxContainer/HBoxContainer/MessageLabel.text = String(seconds)


func _on_StageNodesHandler_say(text):
	$Annoucer.announce(text)


func _on_StageNodesHandler_EndOfStory():
	var _err = get_tree().change_scene("res://Game/Game.tscn")


func _on_World_release():
	add_player_ship()
	PlayerShipInstance.input_inactive = false

func quit():
	UserOptions.quit_hook()
	

func _on_UILayer_quit():
	quit()

func _on_UserOptions_finished():
	get_tree().quit()
