extends Node2D

var identificator = "NecklaceItemStats.tres"

var _stats : Stats
var _global_stats := Stats.new()

func _ready():
	_stats = StatsLibrary.get_item_stats(identificator)
	_global_stats.add(_stats)
