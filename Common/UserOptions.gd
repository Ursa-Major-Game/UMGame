extends Node

var Options
var config: ConfigFile

func _ready():
	Options = UMConfig.new()
	var user_files = FsHelper.list_files_in_directory("user://", [".cfg"])
	if user_files.has("user.cfg"):
		config = Options.load_user_config()
	else:
		config = Options.load_default_config()
	init_screen()

func init_screen():
	OS.window_fullscreen = Options.config.get_value("Screen", "fullscreen")

func quit_hook():
	if not Options.is_equal(config):
		Options.save()
