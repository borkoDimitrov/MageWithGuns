extends Resource

class_name Stats

export var max_health : int = 0
export var health_regen : int = 0
export var lifesteal : int = 0 

export var damage : int = 0
export var melee_damage : int = 0
export var ranged_damage : int = 0 

export var crit_chance : int = 0 

export var attack_cooldown : float = 0
export var attack_speed : float = 0
export var move_speed : int = 0

#TODO use reflection
func add(other : Stats):
	max_health += other.max_health
	health_regen += other.health_regen
	lifesteal += other.lifesteal

	damage += other.damage
	melee_damage += other.melee_damage
	ranged_damage += other.ranged_damage

	crit_chance += other.crit_chance

	attack_cooldown += other.attack_cooldown
	attack_speed += other.attack_speed
	move_speed += other.move_speed

func print_stats():
	print("max_health : ", max_health)
	print("health_regen : ", health_regen)
	print("lifesteal : ", lifesteal)

	print("damage : ", damage)
	print("melee_damage : ", melee_damage)
	print("ranged_damage : ", ranged_damage)

	print("crit_chance : ", crit_chance)
	
	print("attack_cooldown", attack_cooldown)
	print("attack_speed : ", attack_speed)
	print("move_speed : ", move_speed)
	
