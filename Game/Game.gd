extends Node2D

export (PackedScene) var PlayerShip
export (bool) var dbg_straight_to_game = false

var PlayerShipInstance
onready var SpawnPoint: Position2D = $SpawnPosition2D

func start_game(level: int):
	SpawnPoint.add_child(PlayerShipInstance)
	$AsteroidsFactory/Timer.start()

func pause_game():
	$UILayer/Background.open_view()
	yield($UILayer/Background, "opened")
	get_tree().paused = true

func _ready():
	PlayerShipInstance = PlayerShip.instance()
	PlayerShipInstance.get_node("Sprite").modulate.a = 0
	yield($UILayer, "ui_displayed")
	if dbg_straight_to_game: _on_UILayer_start_game()
	
func _on_UILayer_start_game(level = 0):
	$UILayer.vanish()
	start_game(level)
