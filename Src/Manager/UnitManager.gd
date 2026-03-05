extends Node2D

"""
For now this manager will also handle the party.
If this manager does too much, we can refactor it later
and make a separate manager for the party.
"""

# Selected units (global via AutoLoad)
var selected_party_unit: PartyUnit = null
var selected_enemy_unit: EnemyUnit = null

# Resources assigned in Inspector
@export var party_res: Array[PartyRes] = []
@export var enemy_res: Array[EnemyRes] = []

# Runtime unit lists
var party_units: Array[PartyUnit] = []
var enemy_units: Array[EnemyUnit] = []


func _ready() -> void:
	print("Starting UnitManager")
	
	party_units.clear()
	enemy_units.clear()
	
	add_to_party_team()


func _process(delta: float) -> void:
	pass


func add_to_party_team() -> void:
	for i in party_res.size():
		var p_unit := party_res[i].unit_prefab.instantiate() as PartyUnit
		
		p_unit.initialize(party_res[i])
		party_units.insert(i, p_unit)
		add_child(p_unit)
		
		print("Added to party: ", i + 1)


func add_to_enemy_team() -> void:
	if enemy_res.is_empty():
		return
	
	for i in enemy_res.size():
		print("Successfully added enemy on index: ", i)
		
		var e_unit := enemy_res[i].unit_prefab.instantiate() as EnemyUnit
		
		e_unit.initialize(enemy_res[i])
		enemy_units.insert(i, e_unit)
		add_child(e_unit)


func get_party_list() -> Array[PartyUnit]:
	return party_units


func get_enemy_list() -> Array[EnemyUnit]:
	return enemy_units


func set_enemy_res(res: Array[EnemyRes]) -> void:
	enemy_res = res
	add_to_enemy_team()


func get_remaining_party_units() -> int:
	var count := 0
	
	for unit in party_units:
		if unit.is_alive:
			count += 1
	
	return count
