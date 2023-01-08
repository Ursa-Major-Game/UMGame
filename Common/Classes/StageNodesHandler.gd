extends Node

signal Progressed(seconds)
signal EndOfStory
signal say(text)
signal change_surface(tex)
signal change_spawn_texture(tex)

export (int, 0, 100) var Progress = 0
export (String, FILE, "*.story") var StoryFileName

var ProgressFloat : float = 0.0
var StoryConfigFile : ConfigFile
var LoadedStages := {}

var story_name : String
var current_stage_id: int = -1 setget set_current_stage_index
var current_stage : String
var StageOrder : Array

var LastLevelTime : float = 0.0
onready var InitialProgress = Progress

func set_current_stage_index(idx: int):
	if idx >= StageOrder.size():
		ErrorHandler.die("Story " + story_name, "stage index not in stages array. index: " + String(idx))
	else:
		current_stage_id = idx
		current_stage = StageOrder[idx]

func goto_next_stage():
	restartProgress(0)
	if current_stage_id + 1 >= StageOrder.size():
		emit_signal("EndOfStory")
	else:
		set_current_stage_index(current_stage_id + 1)
		emit_signal("say", current_stage)
		if StoryConfigFile.has_section_key(current_stage, "start_message"):
			emit_signal("say", StoryConfigFile.get_value(current_stage, "start_message"))
		if StoryConfigFile.has_section_key(current_stage, "surface"):
			var image_name : String = StoryConfigFile.get_value(current_stage, "surface")
			var tex : Texture
			tex = load("res://Levels/Surfaces/" + image_name + ".png")
			emit_signal("change_surface", tex)
		if StoryConfigFile.has_section_key(current_stage, "spawn_image"):
			var image_name : String = StoryConfigFile.get_value(current_stage, "spawn_image")
			var tex : Texture
			tex = load("res://Levels/Decorations/" + image_name + ".png")
			emit_signal("change_spawn_texture", tex)

func if_has_set(to: Level, from: ConfigFile, section: String, prop: String):
	if from.has_section_key(section, prop):
		var val = from.get_value(section, prop)
		to.set(prop, val)

func get_loaded_stage_levels(stage_name: String) -> Dictionary:
	var StageConf := load_conf_file("res://Levels/Stages/" + stage_name + ".stage")
	var LevelDict = {}
	for s in StageConf.get_sections():
		var N = StageConf.get_value(s, "name")
		var L = Level.new()
		L.level_name = N
		L.appeance_time = int(s)
		if_has_set(L, StageConf, s, "text")
		if_has_set(L, StageConf, s, "v_speed")
		if_has_set(L, StageConf, s, "music")
		L.load_data_from_name()
		LevelDict[int(s)] = L
		LastLevelTime = max(LastLevelTime, int(s))
	return LevelDict
	
func load_stages():
	for s in StoryConfigFile.get_sections():
		StageOrder.append(s)
		LoadedStages[s] = get_loaded_stage_levels(s)

func present_level(L: Level):
	L.transfer_nodes_to(self)
	if L.text: emit_signal("say", L.text)
	if L.music: emit_signal("set_music", L.music)

func start(resume : bool = false):
	set_physics_process(true)
	if not resume:
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
			present_level(LoadedStages[current_stage][int(Progress)])
		
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
