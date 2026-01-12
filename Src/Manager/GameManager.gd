extends Node2D

enum GameState
{
	START_SCREEN,
	OVERWORLD,
	COMBAR
}

var current_game_state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_game_state = GameState.START_SCREEN
	print("Game Manager started")
	print("Game current state: ", current_game_state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_game_state(new_state: GameState) -> void:
	current_game_state = new_state


func get_game_state() -> GameState:
	return current_game_state
