extends Control

class_name DashBoard

@export var end_turn: Button
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open_dashboard() -> void:
	end_turn.disabled = false
	visible = true

func close_dashboard() -> void:
	end_turn.disabled = true
	visible = false

func get_end_turn_button() -> Button:
	return end_turn
