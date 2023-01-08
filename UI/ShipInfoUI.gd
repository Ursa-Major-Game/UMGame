extends Control

export (int) var player_shield = 10 setget set_player_shield
export (int) var player_lifes = 5 setget set_player_lifes

func set_player_shield(v: int):
	player_shield = clamp(v, 0, 10)
	$Screen/VBoxContainer/UIShieldBar.set_value(player_shield)

func set_player_lifes(v: int):
	player_lifes = v
	$Screen/VBoxContainer/UILifesBar.set_value(player_lifes)

func _ready():
	var _err = GamePlayerInfo.connect("set_player_shield", self, "set_player_shield")
	var _err2 = GamePlayerInfo.connect("set_player_lifes", self, "set_player_lifes")

func appear():
	var _modulate = modulate
	_modulate.a = 1.0
	$Tween.interpolate_property(self, "modulate", modulate, _modulate, 0.5)
	$Tween.start()
