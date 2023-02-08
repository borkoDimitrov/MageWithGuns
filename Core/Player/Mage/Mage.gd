class_name Mage
extends KinematicBody2D

var identificator = "DefaultCharacterStats.tres"
export(float, 0.01, 1.0) var drag_factor := 0.12

var health := 0
var velocity := Vector2.ZERO

var stats : Stats
var global_stats : Stats
var items_stats = []

var weapons = []

func _ready():
	stats = StatsLibrary.get_character_stats(identificator)
	global_stats = Stats.new()
	global_stats.add(stats)
	
	_position_weapons_slot_based_on_player(90)
	
func _input(event):
	if event.is_action_pressed("space"):
		var item = StatsLibrary.get_item_stats("NecklaceItemStats.tres")
		items_stats.push_back(item)
		calculate_global_stats()
		
func _position_weapons_slot_based_on_player(length_from_player):
	weapons = {300 : $WeaponsContainer/Sword, 0 : $WeaponsContainer/Sword2, 60 : $WeaponsContainer/Sword3,
	 120 : $WeaponsContainer/Sword4, 180 : $WeaponsContainer/Sword5, 240 : $WeaponsContainer/Sword6}
				
	for degree in weapons.keys():
		var weapon = weapons[degree]

		var radians = deg2rad(degree)
		var x = (length_from_player * cos(radians))
		var y = (length_from_player * sin(radians))
		weapon.position = Vector2(x, y)

func _physics_process(_delta: float):
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var desired_velocity := global_stats.move_speed * direction
	var steering := desired_velocity - velocity
	velocity += steering * drag_factor
	velocity = move_and_slide(velocity, Vector2.ZERO)

func set_health(new_health: int):
	health = clamp(new_health, 0, global_stats.max_health)

func take_damage(amount: int):
	set_health(health - amount)

func calculate_global_stats():
	calculate_global_character_stats()
	calculate_global_weapon_stats()
	
func calculate_global_character_stats():
	global_stats = Stats.new()
	global_stats.add(stats)
	for item in items_stats:
		global_stats.add(item)
		
func calculate_global_weapon_stats():
	for weapon in weapons.values():
		weapon.on_character_global_stats_changed(global_stats)

