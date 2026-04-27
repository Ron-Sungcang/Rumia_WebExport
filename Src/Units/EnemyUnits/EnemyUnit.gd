extends Unit
class_name EnemyUnit

#@export var area_2d: Area2D
@export var texture_button: TextureButton

var unit_played: bool = false

var UnitPlayed: bool:
	get:
		return unit_played
	set(value):
		unit_played = value


func _ready() -> void:
	if texture_button == null:
		print("EnemyUnit, unset collision box")
		return
	
	texture_button.mouse_entered.connect(_on_mouse_entered)
	texture_button.mouse_exited.connect(_on_mouse_exited)
	texture_button.pressed.connect(_on_pressed)


func _process(delta: float) -> void:
	pass


#TODO: Similar to party initialize, refactor later
func initialize(enemy_res: EnemyRes) -> void:
	unit_name = enemy_res.unit_name
	max_hp = enemy_res.max_hp
	total_attack = enemy_res.base_power + power
	
	set_sprite(enemy_res.unit_image)


func _on_pressed() -> void:
	#if event is InputEventMouseButton \
	#and event.button_index == MOUSE_BUTTON_LEFT \
	#and event.pressed:
		
	UnitManager.selected_party_unit = null
	UnitManager.selected_enemy_unit = self
		
	print("CLICKED ", UnitManager.selected_enemy_unit.unit_name)
		
	if UnitManager.selected_party_unit != null:
		print("ERROR: Party Unit still selected")


func _on_mouse_entered() -> void:
	print("MouseEntered")
	CursorManager.pointer_cursor()


func _on_mouse_exited() -> void:
	print("MouseExited")
	CursorManager.default_cursor()
