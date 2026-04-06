extends Control
class_name CombatManager

@export var test_packed: PackedScene # testing only
@export var ui: Control
@export var dashboard: DashBoard
@export var background: TextureRect
@export var combat_bg: TextureRect

@export var party_slot_layers: Array[HBoxContainer]
@export var enemy_slot_layers: Array[HBoxContainer]

@export var player_slots: Array[PartySlot]
@export var enemy_slots: Array[EnemySlot]

var available_p_slots: int
var available_e_slots: int

var reserve_party_units: Array[PartyUnit]
var reserve_enemy_units: Array[EnemyUnit]

var test_selected_stage: CombatStage = null
var state: CombatState

signal start_draw
signal start_combat_signal

enum CombatState {
	START_TURN,
	PLAYER_TURN,
	END_TURN,
	ENEMY_TURN,
	TRANSITION
}

func _ready() -> void:
	dashboard.get_end_turn_button().pressed.connect(end_turn_pressed)

	if test_packed != null:
		test_selected_stage = test_packed.instantiate() as CombatStage

	set_process(false)
	start_combat()


func _process(delta: float) -> void:
	pass

func set_state(new_state: CombatState) -> void:
	print("From:", state, "To:", new_state)
	state = new_state
	_combat_state_entered(state)


func _combat_state_entered(new_state: CombatState) -> void:
	if test_selected_stage != null and not test_selected_stage.combat_stage_over:
		match new_state:
			CombatState.START_TURN:
				start_transition(CombatState.PLAYER_TURN)

			CombatState.PLAYER_TURN:
				dashboard.open_dashboard()
				emit_signal("start_draw")

			CombatState.END_TURN:
				start_transition(CombatState.ENEMY_TURN)

			CombatState.ENEMY_TURN:
				if not test_selected_stage.combat_stage_over:
					print("Remaining units:", test_selected_stage.remaining_units)

				await get_tree().create_timer(1.5).timeout
				start_transition(CombatState.START_TURN)
	# TODO: Dont need this else statement
	else:
		# Combat finished
		if test_selected_stage != null:
			if test_selected_stage.combat_victory:
				print("Victors!")
			else:
				print("Loser!")

		print("Combat over!!!!!!!")
		set_process(false)
		# Return to overworld here

func start_combat() -> void:
	GameManager.set_game_state(GameManager.GameState.COMBAT)
	CursorManager.current_ui = ui

	reset_combat_status()
	
	load_combat_stage_res()
	set_combat_slots()
	
	set_party_positions()
	set_enemy_positions()

	set_process(true)

	print("Current game state:", GameManager.get_game_state())
	print("Starting Combat")

	dashboard.close_dashboard()

	emit_signal("start_combat_signal")
	start_transition(CombatState.START_TURN)


func load_combat_stage_res() -> void:
	if StageManager.selected_combat_res == null:
		print("Empty combat stage on StageManager")
		return
	
	set_background(StageManager.selected_combat_res.background)
	set_combat_bg(StageManager.selected_combat_res.combat_bg)
	
	if StageManager.selected_combat_res.enemy_slots > 6:
		print("Invalid number of enemy slots")
		return
	
	test_selected_stage = (
		StageManager.selected_combat_res.stage_prefab.instantiate()
		as CombatStage
	)

	test_selected_stage.initialize(StageManager.selected_combat_res)
	print("Loaded Combat stage res ", test_selected_stage.name)

func set_combat_slots() -> void:
	if UnitManager.party_units.size() <= 2:
		party_slot_layers[1].visible = false
		available_p_slots = 2
	else:
		party_slot_layers[1].visible = true
		available_p_slots = 4
	
	set_party_slots()
	
	if test_selected_stage.resource.enemy_slots <= 3:
		enemy_slot_layers[1].visible = false
		available_e_slots = 3
		print("Available e slots == 3")
	else:
		enemy_slot_layers[1].visible = true
		available_e_slots = 6
		print("Available e slots == 6")
	
	set_enemy_slots()

func set_party_slots() -> void:
	var curr_slot := 1
	for i in player_slots:
		if curr_slot <= UnitManager.party_units.size():
			i.visible = true
		else:
			i.visible = false
		
		curr_slot += 1
		if curr_slot > available_p_slots:
			return

func set_enemy_slots() -> void:
	var curr_slot := 1
	print("Enemy slots", test_selected_stage.resource.enemy_slots)
	for i in enemy_slots:
		if curr_slot <= test_selected_stage.resource.enemy_slots:
			i.visible = true
		else:
			i.visible = false
			
		curr_slot += 1
		
		if curr_slot > available_e_slots:
			return

func set_party_positions() -> void:
	var party_list = UnitManager.get_party_list()
	if party_list == null:
		print("Party list is null")
		return

	var curr_slot := 1
	for i in party_list.size():
		if curr_slot > player_slots.size():
			reserve_party_units.append(party_list[i])
		
		if party_list[i].is_alive and not player_slots[curr_slot - 1].slot_taken:
			party_list[i].position_slot = curr_slot
			spawn_character(party_list[i], player_slots[curr_slot - 1])
			curr_slot += 1
	
	print("Reserved Party size: ", reserve_party_units.size())


func spawn_character(unit: PartyUnit, slot: PartySlot) -> void:
	#UnitManager.remove_from_party_team(unit)
	slot.add_party_scene(unit)
	unit.visible = true


func set_enemy_positions() -> void:
	print("SetEnemy called")

	var enemy_list = UnitManager.get_enemy_list()
	if enemy_list == null:
		print("Enemy list is null")
		return

	var curr_slot := 1
	for i in enemy_list.size():
		if curr_slot > enemy_slots.size() or curr_slot > test_selected_stage.resource.enemy_slots:
			reserve_enemy_units.append(enemy_list[i])
		
		if enemy_list[i].is_alive and not enemy_slots[curr_slot - 1].slot_taken:
			enemy_list[i].position_slot = curr_slot
			spawn_enemy(enemy_list[i], enemy_slots[curr_slot - 1])
			curr_slot += 1
	
	print("Reserved Enemy size: ", reserve_enemy_units.size())

func spawn_enemy(unit: EnemyUnit, slot: EnemySlot) -> void:
	#UnitManager.remove_from_enemy_team(unit)
	slot.add_enemy_scene(unit)
	unit.visible = true



func reset_combat_status() -> void:
	reserve_party_units.clear()
	reserve_enemy_units.clear()
	
	clear_enemy_slots()
	clear_player_slots()

func clear_enemy_slots() -> void:
	for slot in enemy_slots:
		slot.clear_scene()

func clear_player_slots() -> void:
	if player_slots == null:
		print("Empty player slot")
		return
	for slot in player_slots:
		slot.clear_scene()



func start_transition(next: CombatState) -> void:
	print("Transitioning to:", next)
	set_state(next)

func end_turn_pressed() -> void:
	dashboard.close_dashboard()
	set_state(CombatState.END_TURN)

func set_background(bg: Texture2D) -> void:
	if(bg == null):
		print("Empty background")
		return
	background.texture = bg 

func set_combat_bg(bg: Texture2D) -> void:
	if(bg == null):
		print("Empty combat bg")
		return
	combat_bg.texture = bg
