extends Card
class_name AttackCard

#Resource values on initialize
var damage_type: AttackCardRes.DamageType
var damage: int # BASE DAMAGE
var percentage: float # BASE STAT PERCENT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func initialize(res_file: AttackCardRes) -> void:
	card_name = res_file.card_name
	card_type = res_file.card_type
	card_effects = res_file.base_card_effects
	
	damage_type = res_file.damage_type
	damage = res_file.base_damage
	percentage = res_file.base_percentage
	
	set_image(res_file.card_image)

# Might need local var for total damage?
func play_card() -> void:
	if card_effects.size() == 0:
		Log.log("Empty effects for card %s" % card_name, Log.LogType.ERROR)
	
	if targets.size() == 0:
		Log.log("Empty list of targets for card: %s" % card_name, Log.LogType.ERROR)
	
	var total_damage: float
	
	for t in targets:
		for effects in card_effects:
			if effects is DamageEffect:
				match damage_type:
					AttackCardRes.DamageType.PHYSICAL:
						# Unit attack with percentage and then take enemy physical resistance
						# For def/res, make a func in unit called total_def/total_res,
						# which takes unit def/res stat + def/res changes due to buffs/debuffs
						# Same deal for unit damage
						total_damage = calculate_total_dmg((damage + (percentage * unit.total_attack)), t.def)
					AttackCardRes.DamageType.MAGIC:
						total_damage = calculate_total_dmg((damage + (percentage * unit.total_attack)), t.res)
					AttackCardRes.DamageType.HOLY:
						total_damage = calculate_total_dmg((damage + (percentage * unit.total_attack)), t.res)
				effects.value = total_damage
				
			effects.execute(unit, t)

func calculate_total_dmg(dmg: float, defense: float) -> float:
	if dmg <= defense:
		return 0
	
	return (dmg - defense)
