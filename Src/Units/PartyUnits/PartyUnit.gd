extends Unit

class_name PartyUnit

@export var texture_button: TextureButton
#@export var area_2d: Area2D

func _ready() -> void:
	if texture_button == null:
		print("EnemyUnit, unset collision box")
		return
	
	texture_button.mouse_entered.connect(_on_mouse_entered)
	texture_button.mouse_exited.connect(_on_mouse_exited)
	texture_button.pressed.connect(_on_pressed)


func _process(delta: float) -> void:
	pass


func initialize(party_res: PartyRes) -> void:
	unit_name = party_res.unit_name
	max_hp = party_res.max_hp
	
	total_attack = party_res.base_power
	def = party_res.base_def
	res = party_res.base_res
	
	set_sprite(party_res.unit_image)


func _on_pressed() -> void:
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
