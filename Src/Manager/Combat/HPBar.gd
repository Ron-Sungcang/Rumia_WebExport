extends TextureProgressBar

class_name HPBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func initialize(max_hp: int, current_hp: int) -> void:
	min_value = 0
	max_value = max(1, max_hp)
	value = clamp(current_hp, min_value, max_value)
	
	update_texture()

func new_hp_values(new_max: int, new_current: int) -> void:
	max_value = new_max
	value = new_current
	
	update_texture()

func update_hp(new_hp: int) -> void:
	value = clamp(new_hp, 0, max_value)
	
	update_texture()

func update_texture():
	#TODO: In charge of updating testure of the progress bar
	var hp_ratio = value/max_value
	
	if hp_ratio > 0.6:
		tint_progress = Color(0, 1, 0)
	elif hp_ratio > 0.3:
		tint_progress = Color(1, 1, 0)
	else:
		tint_progress = Color(1, 0, 0)
