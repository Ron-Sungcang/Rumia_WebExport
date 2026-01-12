extends Unit
class_name EnemyUnit

@export var area_2d: Area2D
@export var unit_played: bool = false

var UnitPlayed: bool:
	get:
		return unit_played
	set(value):
		unit_played = value


func _ready() -> void:
	if area_2d == null:
		print("EnemyUnit, unset collision box")
		return
	
	# Godot 4 signal connections
	area_2d.mouse_entered.connect(_on_mouse_entered)
	area_2d.mouse_exited.connect(_on_mouse_exited)
	area_2d.input_event.connect(_on_area_input_event)


func _process(delta: float) -> void:
	pass


func initialize(enemy_res: EnemyRes) -> void:
	unit_name = enemy_res.unit_name
	max_hp = enemy_res.max_hp


func _on_area_input_event(
	viewport: Node,
	event: InputEvent,
	shape_idx: int
) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		
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
