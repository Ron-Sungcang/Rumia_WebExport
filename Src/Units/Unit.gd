extends Node2D
class_name Unit

"""
This class is the base class for all units in the game
There should be more classes that inherit this class
"""

# Basic unit data
var unit_name: String
var max_hp: int

# Exported / editable in inspector
@export var curr_hp: int
@export var is_alive: bool = false
@export var position_slot: int
@export var in_combat: bool = false
@export var unit_image: Sprite2D


# Property equivalent to C# CurrentHP
var current_hp: int:
	get:
		return curr_hp
	set(value):
		curr_hp = value
		
		if curr_hp <= 0:
			print("Super dead")
			is_alive = false


func _ready() -> void:
	# current_hp = max_hp
	pass


func _process(delta: float) -> void:
	pass


func take_damage(damage: int) -> void:
	curr_hp -= damage
	
	if curr_hp <= 0:
		is_alive = false
		# Destroy / queue_free()

func set_sprite(sprite: Texture2D) -> void:
	if(sprite == null):
		print("Party unit sprite is empty")
		return
	
	unit_image.texture = sprite
