extends Control

export (Texture) var LifeTexture
export (String) var LabelName
export (Color) var ColorTint = Color.white

const MAX_VALUE : int = 10

export (int, 0, 10) var value setget set_value

func set_value(v: int):
	v = int(clamp(v, 0, MAX_VALUE))
	value = v
	for c in $HBoxContainer.get_children():
		if c is TextureRect: c.queue_free()
	for i in v:
		var L = TextureRect.new()
		L.texture = LifeTexture
		L.expand = true
		L.modulate = ColorTint
		$HBoxContainer.add_child(L)
		L.rect_min_size = Vector2(16, 16)

func _ready():
	if LabelName:
		$HBoxContainer/Label.text = LabelName
