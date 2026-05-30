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

#TODO: Might have to change for more accurate card description, 
# create the card prefab, they will have a description_format var
# @export var card_description: String
@export var card_image: Texture2D

#CardEffect, the effects of cards being used
# @export var effects: Array[CardEffect] = [] 

#TODO: Create StatusEffect script that is the interface for effects
#	- include base_value
# Cards will have a a func that activates all card effects
