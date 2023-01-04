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

var PlayerShipInstance
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
		SpawnPoint.add_child(PlayerShipInstance)
		PlayerShipInstance.limits.left = $UILayer/Background.get_limits_left()
		PlayerShipInstance.limits.right = $UILayer/Background.get_limits_right()

func start_game():
	$UILayer.vanish()
	$UILayer/Background.open_view()
	yield($UILayer/Background, "opened")
	if get_tree().paused:
		get_tree().paused = false
	else:
		add_player_ship()
	$AsteroidsFactory/Timer.start()
	can_pause = true
	$StageNodesHandler.start()
	GamePlayerInfo.reset()

func pause_game():
	if not can_pause: return
	get_tree().paused = true
	$UILayer.reappear()
	$UILayer/MainMenuUI/HBoxContainer/VBoxContainer/StartButton.text = "Resume"
	yield($UILayer, "ui_displayed")
	can_pause = false

func _ready():
	yield($UILayer, "ui_displayed")
	if dbg_straight_to_game: start_game()
	
func debug_toggle():
	$UIDebugLayer.visible = not $UIDebugLayer.visible

func _process(_delta):
	for gi in game_input.keys():
		if Input.is_action_just_pressed(gi):
			call(game_input[gi])
	
func _on_UILayer_start_game(_level = 0):
	start_game()


func _on_StageNodesHandler_Progressed(seconds):
	$UIDebugLayer/VBoxContainer/HBoxContainer/MessageLabel.text = String(seconds)


func _on_StageNodesHandler_say(text):
	$Annoucer.announce(text)
