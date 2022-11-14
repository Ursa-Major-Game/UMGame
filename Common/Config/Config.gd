extends ConfigFile

func load_config(s: String = "default", to: ConfigFile = self) -> ConfigFile:
	to.clear()
	var err = to.load("user://" + s + ".cfg")
	assert(err == OK)
	return to

func conf_is_valid(s: String):
	if s == "default": return true
	else:
		load_config()
		var c: ConfigFile = load_config(s, ConfigFile.new())
		for s in get_sections():
			for k in get_section_keys(s):
				if not (c.has_section(s) and c.has_section_key(s, k)):
					return false
