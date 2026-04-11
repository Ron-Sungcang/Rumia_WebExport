extends TextureProgressBar


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

func new_hp_values(new_max: int, new_current: int) -> void:
	max_value = new_max
	value = new_current

func update_hp(new_hp: int) -> void:
	value = clamp(new_hp, 0, max_value)

func update_texture():
	#TODO: In charge of updating testure of the progress bar
	pass
