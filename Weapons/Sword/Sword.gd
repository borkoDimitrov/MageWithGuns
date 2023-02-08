extends Node2D

var _stats : Stats
var _global_stats := Stats.new()

var identificator = "SwordStats.tres"
onready var _weapon_sprite = $Sprite
onready var _weapon_ai = $Sprite/weapon_ai

onready var _collision_detection_body = $Sprite/collision_detection_area/shape
onready var _initial_rotation = rotation

var _is_attack_anim_active = false
var _is_character_flipped = false
var _weapon_sprite_local_rotation = 0

var enemy_that_has_been_hitted = []

var enemy_in_sight_of_view = []
var closest_enemy_in_sight_of_view = null

var enemy_in_sight_of_attack = []
var closest_enemy_in_sight_of_attack = null

var _elapsed_time_from_attack = 999999.0

func _ready():
	_stats = StatsLibrary.get_weapon_stats(identificator)
	_global_stats = Stats.new()
	_global_stats.add(_stats)
	
	print(identificator)
	_stats.print_stats()
	print("as", _get_global_attack_cooldown())

func _get_attack_speed_time():
	return range_lerp(_global_stats.attack_speed, 10, 1000, 2, 0.1)
	
func _physics_process(delta):
	_proces_elapsed_time_from_attack(delta)
	_process_sight_of_attack_logic()
	_process_sight_of_view_logic()

func _proces_elapsed_time_from_attack(delta):
	_elapsed_time_from_attack += delta
	
func _process_sight_of_view_logic():
	if _is_attack_anim_active:
		return
	
	if closest_enemy_in_sight_of_view == null:
		if _is_character_flipped:
			$Sprite.scale.x = -1
		else:
			$Sprite.scale.x = 1
		
		_weapon_sprite.rotation = 0
		return
		
	var target_position = closest_enemy_in_sight_of_view.global_position
	_look_at_position(target_position)
		
func _look_at_position(target_pos):
	_weapon_sprite.look_at(target_pos)
	if _is_character_flipped:
		_weapon_sprite.rotation_degrees += 180

func _process_sight_of_attack_logic():
	if closest_enemy_in_sight_of_attack == null:
		return
	
	if _can_attack_enemy():
		_attack_enemy()

func _can_attack_enemy():
	if _is_attack_anim_active:
		return false
	return _elapsed_time_from_attack >= _get_global_attack_cooldown()

func _get_global_attack_cooldown():
	return _global_stats.attack_cooldown / (_global_stats.attack_speed / 100)
	
func _attack_enemy():
	var move_to_time = 0.3
	var return_back_time = 0.3
	
	var target_pos = closest_enemy_in_sight_of_attack.global_position
	
	_on_attack_animation_start()
	_look_at_position(target_pos)
	
	var scene_tree_tween = get_tree().create_tween()
	scene_tree_tween.tween_callback(self, "_enable_collision_detection")
	scene_tree_tween.tween_property(_weapon_sprite, "global_position", target_pos, move_to_time).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	scene_tree_tween.tween_callback(self, "_disable_collision_detection")
	scene_tree_tween.tween_property(_weapon_sprite, "position", Vector2.ZERO, return_back_time).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	scene_tree_tween.tween_callback(self, "_on_attack_animation_stop")
		
func _enable_collision_detection():
	_collision_detection_body.disabled = false
	enemy_that_has_been_hitted = []

func _disable_collision_detection():
	_collision_detection_body.disabled = true

func _on_collision_detection_area_body_entered(body):
	if enemy_that_has_been_hitted.has(body):
		return
	
	enemy_that_has_been_hitted.push_back(body)
	print("hit enemy - ", body)

func _on_sight_of_attack_body_entered(body):
	enemy_in_sight_of_attack.push_back(body)
	_find_closest_enemy_in_sight_of_attack()

func _on_sight_of_attack_body_exited(body):
	enemy_in_sight_of_attack.erase(body)
	_find_closest_enemy_in_sight_of_attack()

func _find_closest_enemy_in_sight_of_attack():
	closest_enemy_in_sight_of_attack = _find_closest_enemy_impl(enemy_in_sight_of_attack)
	
func _on_sight_of_view_body_entered(body):
	enemy_in_sight_of_view.push_back(body)
	_find_closest_enemy_in_sight_of_view()

func _on_sight_of_view_body_exited(body):
	enemy_in_sight_of_view.erase(body)
	_find_closest_enemy_in_sight_of_view()
	
func _find_closest_enemy_in_sight_of_view():
	closest_enemy_in_sight_of_view = _find_closest_enemy_impl(enemy_in_sight_of_view)

func _find_closest_enemy_impl(enemy_list):
	var closest_enemy = null
	var closest_distance = 1000000
	
	for enemy in enemy_list:
		var distance_to_enemy = position.distance_to(enemy.position)
		if distance_to_enemy < closest_distance:
			closest_distance = distance_to_enemy
			closest_enemy = enemy
			
	return closest_enemy

func on_character_flip_changed(is_fliped):	
	_is_character_flipped = is_fliped

func _on_attack_animation_start():
	_is_attack_anim_active = true
	
func _on_attack_animation_stop():
	_is_attack_anim_active = false
	_elapsed_time_from_attack = 0.0
	
func on_character_global_stats_changed(character_global_stats : Stats):
	_global_stats = Stats.new()
	_global_stats.add(_stats)
	_global_stats.add(character_global_stats)
