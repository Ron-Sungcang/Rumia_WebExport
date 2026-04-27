extends Resource
class_name CardRes

#Interface for all the cards

enum CardType {
	ATTACK,
	DEFENSE,
	SUPPORT,
}

@export var card_name: String
@export var card_type: CardType
@export var card_description: String

#CardEffect, the effects of cards being used
@export var effects: Array[CardEffect] = [] 
