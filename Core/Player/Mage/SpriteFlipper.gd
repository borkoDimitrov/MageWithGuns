extends AnimatedSprite

func _physics_process(_delta: float):
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction_key := direction.round()
	
	direction_key.x = abs(direction_key.x)
	
	if direction_key.x || direction_key.y != 0:
		play("Walk")
	else:
		play("Idle")
	
	if direction_key:
		var is_left = sign(direction.x) == -1
		
		flip_h = is_left
		for weapon in get_parent().weapons.values():
			weapon.on_character_flip_changed(is_left)

func die():
	set_physics_process(false)
	
