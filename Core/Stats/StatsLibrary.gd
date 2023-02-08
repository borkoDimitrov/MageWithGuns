extends Node

var character_stats = {}
var weapon_stats = {}
var item_stats = {}

func _ready():
	read_directory("res://Resources/Character/", character_stats)
	read_directory("res://Resources/Weapon/", weapon_stats)
	read_directory("res://Resources/Items/", item_stats)
	
func read_directory(path, stats_list):
	var dir = Directory.new()
	if dir.open(path) != OK:
		print("An error occurred when trying to access the path.")
		return
		
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if false == dir.current_is_dir():
			stats_list[file_name] = load_stats_resources(path + file_name)
		file_name = dir.get_next()

func load_stats_resources(file_name):
	var stats = ResourceLoader.load(file_name)
	assert(stats != null)
	return stats

func get_character_stats(id):
	return character_stats[id]

func get_weapon_stats(id):
	return weapon_stats[id]
	
func get_item_stats(id):
	return item_stats[id]
