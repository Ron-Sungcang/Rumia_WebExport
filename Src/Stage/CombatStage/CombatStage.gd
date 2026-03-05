extends Stage

class_name CombatStage

# Assigned during initialization
var resource: CombatStageRes 

@export var remaining_units: int
@export var remaining_enemies: int

@export var combat_stage_over: bool = false
@export var combat_victory: bool = false


# Property equivalent to C# RemainingUnits
var RemainingUnits: int:
	get:
		return remaining_units
	set(value):
		remaining_units = value
		
		if remaining_units <= 0:
			# Play losing animation, etc.
			combat_stage_over = true
			combat_victory = false


# Property equivalent to C# RemainingEnemies
var RemainingEnemies: int:
	get:
		return remaining_enemies
	set(value):
		remaining_enemies = value
		
		if remaining_enemies <= 0:
			# Play victory animation, etc.
			combat_stage_over = true
			combat_victory = true


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


# Instead of Ready(), explicit initialization
func initialize(res: CombatStageRes) -> void:
	resource = res
	
	# Safety check: ensure enemy count matches resource data
	if resource.total_enemies != resource.list_of_enemies.size():
		resource.total_enemies = resource.list_of_enemies.size()
	
	RemainingEnemies = resource.total_enemies
	
	# AutoLoad access (NO Instance)
	UnitManager.set_enemy_res(resource.list_of_enemies)
	RemainingUnits = UnitManager.get_remaining_party_units()
