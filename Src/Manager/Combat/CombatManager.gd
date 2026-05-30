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
	Log.log("From state: %s To state: %s" % [state, new_state], Log.LogType.STATE_CHANGE)
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
					Log.log("Remaining units: %d" % test_selected_stage.remaining_units, Log.LogType.VALUE_CHECK)

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
	Log.log("Current game state: %d" % GameManager.get_game_state(), Log.LogType.STATE_CHANGE)
	Log.log("Starting combat", Log.LogType.LOGGING)
	CursorManager.current_ui = ui

	reset_combat_status()
	
	load_combat_stage_res()
	set_combat_slots()
	
	#Refactor since party positions are basically the same code
	#Make a new function that just assigns units to slots used by both
	set_party_positions()
	set_enemy_positions()

	set_process(true)

	dashboard.close_dashboard()

	emit_signal("start_combat_signal")
	start_transition(CombatState.START_TURN)


func load_combat_stage_res() -> void:
	if StageManager.selected_combat_res == null:
		Log.log("Empty combat stage on StageManager", Log.LogType.ERROR)
		return
	
	set_background(StageManager.selected_combat_res.background)
	set_combat_bg(StageManager.selected_combat_res.combat_bg)
	
	if StageManager.selected_combat_res.enemy_slots > 6:
		Log.log("Invalid number of enemy slots", Log.LogType.ERROR)
		return
	
	test_selected_stage = (
		StageManager.selected_combat_res.stage_prefab.instantiate()
		as CombatStage
	)

	test_selected_stage.initialize(StageManager.selected_combat_res)
	Log.log("Loaded Combat stage res %s" % test_selected_stage.name, Log.LogType.LOGGING)

func set_combat_slots() -> void:
	var e_slot_count = 0
	
	available_p_slots = 2 if UnitManager.party_units.size() <= 2 else 4
	party_slot_layers[1].visible = available_p_slots > 2
	set_slot_visibility(player_slots, UnitManager.party_units.size())
	
	e_slot_count = test_selected_stage.resource.enemy_slots
	available_e_slots = 3 if e_slot_count <= 3 else 6
	enemy_slot_layers[1].visible = available_e_slots > 3
	set_slot_visibility(enemy_slots, e_slot_count if e_slot_count < available_e_slots else available_e_slots)

func set_slot_visibility(slots: Array, available_slots: int) -> void:
	for i in range(slots.size()):
		slots[i].visible = i < available_slots

func set_party_positions() -> void:
	var party_list = UnitManager.get_party_list()
	
	if party_list == null:
		Log.log("Party list is null", Log.LogType.WARNING)
		return

	var curr_slot := 1
	for i in party_list.size():
		if curr_slot > player_slots.size():
			reserve_party_units.append(party_list[i])
		
		if party_list[i].is_alive and not player_slots[curr_slot - 1].slot_taken:
			party_list[i].position_slot = curr_slot
			spawn_character(party_list[i], player_slots[curr_slot - 1])
			curr_slot += 1
	
	Log.log("Reserved Party size: %s" % reserve_party_units.size(), Log.LogType.VALUE_CHECK)


func spawn_character(unit: PartyUnit, slot: PartySlot) -> void:
	#UnitManager.remove_from_party_team(unit)
	slot.add_party_scene(unit)
	unit.visible = true


func set_enemy_positions() -> void:
	var enemy_list = UnitManager.get_enemy_list()
	if enemy_list == null:
		Log.log("Enemy list is null", Log.LogType.WARNING)
		return

	var curr_slot := 1
	for i in enemy_list.size():
		if curr_slot > enemy_slots.size() or curr_slot > test_selected_stage.resource.enemy_slots:
			reserve_enemy_units.append(enemy_list[i])
		
		if enemy_list[i].is_alive and not enemy_slots[curr_slot - 1].slot_taken:
			enemy_list[i].position_slot = curr_slot
			spawn_enemy(enemy_list[i], enemy_slots[curr_slot - 1])
			curr_slot += 1
	
	Log.log("Reserved Enemy size: %s" % reserve_enemy_units.size(), Log.LogType.VALUE_CHECK)

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
		Log.log("Empty player slot", Log.LogType.ERROR)
		return
	for slot in player_slots:
		slot.clear_scene()

func start_transition(next: CombatState) -> void:
	Log.log("Transitioning to: %s" % next, Log.LogType.LOGGING)
	set_state(next)

func end_turn_pressed() -> void:
	dashboard.close_dashboard()
	set_state(CombatState.END_TURN)

func set_background(bg: Texture2D) -> void:
	if(bg == null):
		Log.log("Empty background", Log.LogType.ERROR)
		return
	background.texture = bg 

func set_combat_bg(bg: Texture2D) -> void:
	if(bg == null):
		Log.log("Empty combat bg", Log.LogType.ERROR)
		return
	combat_bg.texture = bg
