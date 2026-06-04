extends CardRes
class_name AttackCardRes

enum DamageType
{
	PHYSICAL,
	MAGIC,
	HOLY
}

@export var damage_type: DamageType
@export var base_damage: int
@export var base_percentage: float
