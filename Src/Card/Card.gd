extends Control

class_name Card

var cardData
var stateMachine

@export var ColorRectNode: ColorRect
@export var StateLabel: Label

signal CardClicked(card)
signal CardHovered(card)
signal CardExit(card)
#signal CardClickedOutside(card)

func setScaleValue(scale_val: float):
	scale = Vector2(scale_val, scale_val)

func setData(newCardData: CardRes):
	cardData = newCardData
	StateLabel.text = cardData.Name

func UseCards():
	print("Dealt damage")
	
func _ready() -> void:
	if ColorRectNode == null:
		ColorRectNode = get_node("Color")
	if StateLabel == null:
		StateLabel = get_node("State")
	stateMachine = get_node("CardStateMachine")
	stateMachine.init(self)
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("Pressed card")
			emit_signal("CardClicked", self)

func _on_mouse_entered():
	print("Card Hovered")
	emit_signal("CardHovered", self)

func _on_mouse_exited():
	print("Card Exited")
	emit_signal("CardExit", self)
