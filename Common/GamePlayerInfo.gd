extends Node

signal set_player_shield(shield)
signal set_player_lifes(lifes)

var shield : int = 100 setget set_shield

func set_shield(v: int):
	emit_signal("set_player_shield", v)

func set_lifes(l: int):
	emit_signal("set_player_lifes", l)
