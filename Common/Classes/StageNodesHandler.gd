extends Node

signal Progressed(seconds)
signal EndOfStory

export (int, 0, 100) var Progress = 0
export (String, FILE, "*.story") var StoryFileName

var ProgressFloat : float = 0.0
var StoryConfigFile : ConfigFile
var LoadedStages := {}

var story_name : String
var current_stage_id: int = 0 setget set_current_stage_index
var current_stage : String
var StageOrder : Array

func set_current_stage_index(idx: int):
	if idx >= StageOrder.size():
		ErrorHandler.die("Story " + story_name, "stage index not in stages array")
	current_stage_id = idx
	current_stage = StageOrder[idx]

func goto_next_stage():
	if current_stage_id >= StageOrder.size():
		emit_signal("EndOfStory")
		ErrorHandler.die("End of Story" + story_name, "")
	else:
		set_current_stage_index(current_stage_id + 1)

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
		if not (s == "Meta"):
			LoadedStages[s] = load_levels(StoryConfigFile.get_value(s, "levels"))
		else:
			StageOrder = StoryConfigFile.get_value(s, "order")

func start():
	set_physics_process(true)
	set_current_stage_index(0)

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
			LoadedStages[current_stage][int(Progress)].transfer_nodes_to(self)

func load_story(s: String) -> ConfigFile:
	var to = ConfigFile.new()
	to.clear()
	var err = to.load(s)
	if err != OK:
		ErrorHandler.die("Story not found", "can't open story file: " + s)
	story_name = s
	return to
