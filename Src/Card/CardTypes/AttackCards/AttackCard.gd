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
func play_card(p_unit: PartyUnit, card_targets: Array[EnemyUnit]) -> void:
	pass
