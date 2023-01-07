extends Control

export (Texture) var LifeTexture

func set_value(v: int):
	for c in $HBoxContainer.get_children():
		if c is TextureRect: c.queue_free()
	for i in v:
		var L = TextureRect.new()
		L.texture = LifeTexture
		L.expand = true
		$HBoxContainer.add_child(L)
		L.rect_min_size = Vector2(16, 16)
