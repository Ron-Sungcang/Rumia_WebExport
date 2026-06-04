extends Control
class_name Card

enum CardStatus
{
	IN_HAND,
	IN_DECK,
	IN_GRAVEYARD
}

# Resource values on initialize
var card_name: String
var card_type: CardRes.CardType
var card_effects: Array[CardEffect] # On initialize, propagate with resource card effects

var card_status: CardStatus

# Unit and target
var unit: PartyUnit
var targets: Array[EnemyUnit]

@export var card_image: TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_card(p_unit: PartyUnit, card_targets: Array[EnemyUnit]) -> void:
	pass

func set_unit(p_unit: PartyUnit) -> void:
	unit = p_unit
	
func remove_unit() -> void:
	unit = null
	
func add_target(e_unit: EnemyUnit) -> void:
	targets.append(e_unit)

func remove_targets() -> void:
	#TODO: For now only turning targets to an empty array, later update for needs
	targets = []

func set_image(image: Texture2D) -> void:
	if(image == null):
		print("Card image is empty")
		return
	
	card_image.texture = image
