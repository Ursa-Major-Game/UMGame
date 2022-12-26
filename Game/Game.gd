extends Node2D

export (PackedScene) var PlayerShip
export (bool) var dbg_straight_to_game = false

export (PackedScene) var Stage
var PlayerShipInstance
onready var SpawnPoint: Position2D = $SpawnPosition2D

func add_player_ship():
	PlayerShipInstance = PlayerShip.instance()
	PlayerShipInstance.get_node("Sprite").modulate.a = 0
	if PlayerShipInstance:
		SpawnPoint.add_child(PlayerShipInstance)
		PlayerShipInstance.limits.left = $UILayer/Background.get_limits_left()
		PlayerShipInstance.limits.right = $UILayer/Background.get_limits_right()

func start_game():
	$UILayer/Background.open_view()
	yield($UILayer/Background, "opened")
	add_player_ship()
	$AsteroidsFactory/Timer.start()

func pause_game():
	$UILayer/Background.close_view()
	yield($UILayer/Background, "closed")
	get_tree().paused = true

func _ready():
	yield($UILayer, "ui_displayed")
	if dbg_straight_to_game: _on_UILayer_start_game()
	
func _on_UILayer_start_game(level = 0):
	$UILayer.vanish()
	start_game()
