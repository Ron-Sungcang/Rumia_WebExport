extends Resource
class_name CardRes

enum CardType {
	ATTACK,
	DEFENSE,
	SUPPORT,
}

@export var card_name: String
@export var card_type: CardType
@export var card_description: String
