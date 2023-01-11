extends Node

signal finished

var Options
var loaded_config: ConfigFile

func _ready():
	Options = UMConfig.new()
	var user_files = FsHelper.list_files_in_directory("user://", ["cfg"])
	print(user_files)
	if user_files.has("user.cfg"):
		loaded_config = Options.load_user_config()
		print("user file loaded")
	else:
		loaded_config = Options.load_default_config()
		print("default file loaded")
	init_screen()

func init_screen():
	OS.window_fullscreen = loaded_config.get_value("Screen", "fullscreen")

func quit_hook():
	Options.save(loaded_config)
	emit_signal("finished")
