extends Control

export (int) var player_health = 100 setget set_player_health

func set_player_health(v: int):
	player_health = clamp(v, 0, 100)
	$VBoxContainer/UIBar.set_value(player_health)

func _ready():
	GamePlayerInfo.connect("set_health_bar", self, "set_player_health")

func appear():
	var _modulate = modulate
	_modulate.a = 1.0
	$Tween.interpolate_property(self, "modulate", modulate, _modulate, 0.5)
	$Tween.start()
