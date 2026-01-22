extends Node2D

# Currently active UI control that owns the cursor
var current_ui: Control

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

func pointer_cursor() -> void:
	if current_ui == null:
		return
		
	#current_ui.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func default_cursor() -> void:
	if current_ui == null:
		return
	
	#current_ui.mouse_default_cursor_shape = Control.CURSOR_ARROW
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
