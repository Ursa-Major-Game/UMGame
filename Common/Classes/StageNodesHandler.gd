extends Node

signal Progressed(seconds)

export (int, 0, 100) var Progress = 0
export (String, FILE, "*.story") var StoryFileName

var ProgressFloat : float = 0.0
var StoryConfigFile : ConfigFile
var LoadedStages := {}

func load_level(levelname: String) -> Level:
	var L : Level = Level.new()
	L.level_name = levelname
	L.level_data = load("res://Levels/StageNodes/" + levelname + ".tscn")
	return L
	
func load_levels(levelnamedict: Dictionary) -> Dictionary:
	var dict := {}
	for l in levelnamedict.keys():
		var app_time = levelnamedict[l]
		dict[app_time] = load_level(l)
	return dict

func load_stages():
	for s in StoryConfigFile.get_sections():
		LoadedStages[s] = load_levels(StoryConfigFile.get_value(s, "levels"))
		
func start():
	set_physics_process(true)

func _ready():
	ProgressFloat = float(Progress)
	StoryConfigFile = load_story(StoryFileName)
	load_stages()
	set_physics_process(false)

func _physics_process(delta):
	ProgressFloat += delta
	var oldProgress = Progress
	Progress = round(ProgressFloat)
	if oldProgress != Progress: 
		emit_signal("Progressed", Progress)
		if LoadedStages["Stage01"].has(int(Progress)): 
			LoadedStages["Stage01"][int(Progress)].transfer_nodes_to(get_parent())

func load_story(s: String) -> ConfigFile:
	var to = ConfigFile.new()
	to.clear()
	var err = to.load(s)
	if err != OK:
		ErrorHandler.die("Story not found", "can't open story file: " + s)
	return to
