extends Node
class_name Card_State_Machine

@export var initial_state: Card_State

var current_state: Card_State
var states := {}
var events: Events

func init(cardUI: Card):
	for child in get_children():
		var state: Card_State = child
		states[state.current_state] = state
		state.cardUI = cardUI
	
	events = get_node("/root/Events")
	
	#connect signals
	cardUI.CardClicked.connect(_on_card_clicked)
	cardUI.CardHovered.connect(_on_card_hovered)
	cardUI.CardExit.connect(_on_card_exit)
	
	if initial_state != null:
		initial_state.enter(initial_state.current_state)
		current_state = initial_state

func _on_card_clicked(card: Card):
	events.emit_signal("CardAimStarted", card)
	ChangeState(Card_State.State.Clicked)

func _on_card_hovered(card):
	ChangeState(Card_State.State.Hovering)


func _on_card_exited(card):
	change_state(Card_State.State.Exited)


func _on_card_idle(card):
	ChangeState(Card_State.State.Idle)

func ChangeState(state):

	if current_state != null \
	and current_state.current_state == Card_State.State.Clicked \
	and (state == Card_State.State.Hovering or state == Card_State.State.Exited):
		print("Skipping hovered because current state is clicked")
		return

	current_state = states[state]
	current_state.enter(state)
