extends CardEffect
class_name DamageEffect

@export var value: int = 0

func execute(source: Unit, target: Unit) -> void:
	if target:
		target.take_damage(value)
