extends CardEffect
class_name DamageEffect

var value: float

func execute(_source: Unit, target: Unit) -> void:
	if not target:
		return
	
	
	# TODO: instead of source.total_attack, make a variable in attack card that takes percent of units att stat + card base
	# THEN, take the attack card damage type and target resistance
	var final_dmg: int = int(value)
	target.take_damage(final_dmg)
	
