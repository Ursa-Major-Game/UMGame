extends AudioStreamPlayer
class_name AudioStreamPlayerFolder

export (String, DIR) var Folder

func play_random_file_in_folder(_from_pos: float):
	var files = FsHelper.list_files_in_directory(Folder, ["ogg", "mp3", "wav"])
	files.shuffle()
	var p = Folder + "/" + files.pop_back()
	stream = load(p)
	.play()
	
func play(from_pos: float = 0.0) -> void:
	play_random_file_in_folder(from_pos)
