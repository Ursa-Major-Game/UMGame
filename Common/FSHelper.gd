extends Node

func list_files_in_directory(path: String, auth_ext: Array = []) -> Array:
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "": break
		var extensions = file.split(".")
		var ext_nb = extensions.size()
		if ext_nb < 2 : continue
		var ext = extensions[1]
		if not auth_ext.has(ext) or ext_nb > 2: continue
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files
