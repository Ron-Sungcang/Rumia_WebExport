extends CardEffect
class_name DamageEffect

@export var value: int = 1

func execute(source: Unit, target: Unit) -> void:
	if not target:
		return
	
	var final_damage := value
	final_damage = source.total_attack + value
	
	target.take_damage(final_damage)
	
