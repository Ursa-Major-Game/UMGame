extends Control

onready var progress_bar = $ProgressBar
onready var initial_color: Color = progress_bar.get("custom_styles/fg").bg_color

func set_value(v: int):
	var iv = progress_bar.value
	$Tween.interpolate_property(progress_bar, "value", iv, v, 0.2)
	$Tween.start()
	progress_bar.get("custom_styles/fg").bg_color.r = initial_color.r / v * 100
	print(progress_bar.get("custom_styles/fg").bg_color.r)
