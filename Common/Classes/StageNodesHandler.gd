extends Node

signal Progressed(seconds)
signal EndOfStory
signal say(text)

export (int, 0, 100) var Progress = 0
export (String, FILE, "*.story") var StoryFileName

var ProgressFloat : float = 0.0
var StoryConfigFile : ConfigFile
var LoadedStages := {}

var story_name : String
var current_stage_id: int = -1 setget set_current_stage_index
var current_stage : String
var StageOrder : Array
var StageHash: Dictionary

var LastLevelTime : float = 0.0
onready var InitialProgress = Progress

func set_current_stage_index(idx: int):
	if idx > StageOrder.size() - 1:
		ErrorHandler.die("Story " + story_name, "stage index not in stages array. index: " + String(idx))
	current_stage_id = idx
	current_stage = StageOrder[idx]

func goto_next_stage():
	restartProgress(0)
	if current_stage_id >= StageOrder.size() - 1:
		emit_signal("EndOfStory")
		ErrorHandler.die("End of Story" + story_name, "")
	else:
		set_current_stage_index(current_stage_id + 1)
		emit_signal("say", current_stage)

func get_loaded_stage_levels(stage_name: String) -> Dictionary:
	var StageConf := load_conf_file("res://Levels/Stages/" + stage_name + ".stage")
	var LevelDict = {}
	for s in StageConf.get_sections():
		var N = StageConf.get_value(s, "name")
		var L = Level.new()
		L.level_name = N
		L.appeance_time = int(s)
		L.load_data_from_name()
		LevelDict[int(s)] = L
		LastLevelTime = max(LastLevelTime, int(s))
	return LevelDict
	
func load_stages():
	for s in StoryConfigFile.get_sections():
		StageOrder.append(s)
		LoadedStages[s] = get_loaded_stage_levels(s)
		
func start():
	set_physics_process(true)
	goto_next_stage()
	
func restartProgress(i : int = InitialProgress):
	Progress = i
	ProgressFloat = float(Progress)

func _ready():
	restartProgress()
	StoryConfigFile = load_conf_file(StoryFileName)
	load_stages()
	set_physics_process(false)

func _physics_process(delta):
	ProgressFloat += delta
	var oldProgress = Progress
	Progress = round(ProgressFloat)
	if oldProgress != Progress: 
		emit_signal("Progressed", Progress)
		if LoadedStages[current_stage].has(int(Progress)): 
			LoadedStages[current_stage][int(Progress)].transfer_nodes_to(self)
		
		if Progress >= LastLevelTime:
			var cc = get_child_count()
			if cc == 0: 
				goto_next_stage()

func load_conf_file(s: String) -> ConfigFile:
	var to = ConfigFile.new()
	to.clear()
	var err = to.load(s)
	if err != OK:
		ErrorHandler.die("Story not found", "can't open story file: " + s)
	story_name = s
	return to
