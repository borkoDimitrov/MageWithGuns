extends Control

const file_name = "res://Resources/Items/item_test.tres"

func _unhandled_input(event):
	if event.is_action_pressed("space"):
		save_item()
	if event.is_action_pressed("ui_left"):
		load_item()
		
func save_item():
	var stats := Stats.new()
	stats.damage = 5
	stats.health = 3
	stats.move_speed = 1
	stats.dodge = 100
	
	var result = ResourceSaver.save(file_name, stats, 4)
	assert(result == OK)

func load_item():
	if ResourceLoader.exists(file_name):
		var stats = ResourceLoader.load(file_name)
