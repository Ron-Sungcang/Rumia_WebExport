extends CardEffect
class_name DamageEffect

func execute(source: Unit, target: Unit) -> void:
	if not target:
		return
	
	var final_damage := base_value
	
	# TODO: instead of source.total_attack, make a variable in attack card that takes percent of units att stat + card base
	# THEN, take the attack card damage type and target resistance
	final_damage = source.total_attack + base_value
	
	target.take_damage(final_damage)
	
