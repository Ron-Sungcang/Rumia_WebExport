extends Node
class_name Card_State

var position_init: bool = false

enum State {
	Idle,
	Hovering,
	Clicked,
	Used,
	Exited
}

var current_state: State = State.Idle
var cardUI: Card

func SetState(new_state: State) -> void:
	enter(new_state)

func enter(new_state: State) -> void:
	if not position_init and cardUI != null:
		cardUI.pivot_offset = cardUI.size / 2
		position_init = true
	
	current_state = new_state
	
	match new_state:
		State.Idle:
			cardUI.scale = Vector2.ONE
		State.Hovering:
			cardUI.scale = Vector2(1.2, 1.2)
		State.Clicked:
			cardUI.scale = Vector2(1.2, 1.2)
		State.Exited:
			cardUI.scale = Vector2.ONE
		State.Used:
			cardUI.use_cards()
			cardUI.scale = Vector2.ONE
