extends Node
class_name UMConfig

var config : ConfigFile
var path: String

func load_config(s: String = "default") -> ConfigFile:
	var to = ConfigFile.new()
	to.clear()
	if s == "default":
		path = "res://default.cfg"
	else:
		path = "user://" + s + ".cfg"
	to.load(path)
	config = to
	return to

func load_default_config() -> ConfigFile:
	return load_config("default")

func load_user_config() -> ConfigFile:
	var default_config = load_default_config()
	var user_config = load_config("user")
	for s in user_config.get_sections():
		if default_config.has_section(s):
			for k in user_config.get_section_keys(s):
				if default_config.has_section_key(s):
					default_config.set_value(s, k, user_config.get_value(s, k))
	return default_config

func conf_is_complete(s: String):
	if s == "default": return true
	else:
		var default_config = load_default_config()
		var c: ConfigFile = load_config(s)
		for s in default_config.get_sections():
			for k in default_config.get_section_keys(s):
				if not (c.has_section(s) and c.has_section_key(s, k)):
					return false
		return true

func is_equal(to: ConfigFile) -> bool:
	for s in config.get_sections():
		if not to.has_section(s): return false
		else:
			for k in config.get_section_keys(s):
				if not to.has_section_key(s, k): return false
				elif to.get_value(s, k) != config.get_value(s, k): return false
	return true
	
func save():
	if config and path:
		config.save(path)
