extends Control

func set_value(v: int):
	var iv = $TextureProgress.value
	$Tween.interpolate_property($TextureProgress, "value", iv, v, 0.5)
	$Tween.start()
