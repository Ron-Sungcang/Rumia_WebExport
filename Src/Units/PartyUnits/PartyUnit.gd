extends Unit
class_name PartyUnit

@export var area_2d: Area2D


func _ready() -> void:
	if area_2d == null:
		print("PartyUnit, unset collision box")
		return
	
	area_2d.mouse_entered.connect(_on_mouse_entered)
	area_2d.mouse_exited.connect(_on_mouse_exited)
	area_2d.input_event.connect(_on_area_input_event)


func _process(delta: float) -> void:
	pass


func initialize(party_res: PartyRes) -> void:
	unit_name = party_res.unit_name
	max_hp = party_res.max_hp


func _on_area_input_event(
	viewport: Node,
	event: InputEvent,
	shape_idx: int
) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		
		UnitManager.selected_enemy_unit = null
		UnitManager.selected_party_unit = self
		
		print("CLICKED ", UnitManager.selected_party_unit.unit_name)
		
		if UnitManager.selected_enemy_unit != null:
			print("ERROR: Enemy Unit still selected")


func _on_mouse_entered() -> void:
	print("MouseEntered")
	CursorManager.pointer_cursor()


func _on_mouse_exited() -> void:
	print("MouseExited")
	CursorManager.default_cursor()
