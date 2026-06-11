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
var unit: Unit
var targets: Array[Unit]

@export var card_image: TextureRect
@export_multiline var card_description: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_card() -> void:
	pass

func set_unit(u_unit: Unit) -> void:
	unit = u_unit
	
func remove_unit() -> void:
	unit = null
	
func add_target(t_unit: Unit) -> void:
	targets.append(t_unit)

func remove_targets() -> void:
	#TODO: For now only turning targets to an empty array, later update for needs
	targets = []

func set_image(image: Texture2D) -> void:
	if(image == null):
		print("Card image is empty")
		return
	
	card_image.texture = image
