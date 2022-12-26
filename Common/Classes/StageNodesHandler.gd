extends Node

export (int, 0, 100) var Progress = 0
export (String, FILE, "*.tscn") var StoryFileName

var ProgressFloat : float = 0.0
var StoryConfigFile : ConfigFile
var StageNodeScenes := {}

func preload_stages():
	for s in StoryConfigFile.get_sections():
		var i = 0
		for k in StoryConfigFile.get_section_keys(s):
			StageNodeScenes[k] = load("res://Levels/StageNodes/" + k + ".tscn")

func _ready():
	ProgressFloat = float(Progress)
	StoryConfigFile = load_story(StoryFileName)

func _physics_process(delta):
	ProgressFloat += delta
	Progress = round(ProgressFloat)

func load_story(s: String) -> ConfigFile:
	var to = ConfigFile.new()
	to.clear()
	var err = to.load(s)
	assert(err == OK)
	
	return to
