extends Control
class_name PartySlot

@export var slot_number: int
@export var slot_taken: bool = false

var unit_scene: PartyUnit = null


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func add_party_scene(new_scene: PartyUnit) -> void:
	if slot_taken:
		Log.log("PartySlot, AddPartyScene, Party Slot: %d is not empty" % slot_number, Log.LogType.WARNING)
		return
	elif get_child_count() > 0:
		Log.log("PartySlot, AddPartyScene, Party Slot: %d contains a child" % slot_number, Log.LogType.WARNING)
		return

	unit_scene = new_scene
	#add_child(unit_scene)
	unit_scene.reparent(self, false)

	unit_scene.in_combat = true
	slot_taken = true

	Log.log("Successfully added Party unit: %s to slot: %s at pos: %s" % [unit_scene, slot_number, unit_scene.position], Log.LogType.VALUE_CHECK)


func clear_scene() -> void:
	if not slot_taken:
		Log.log("PartySlot, ClearScene, Party Slot: %d is empty" % slot_number, Log.LogType.VALUE_CHECK)
		return
	elif get_child_count() <= 0:
		Log.log("PartySlot, ClearScene, Party Slot: %d doesn't contain a child" % slot_number, Log.LogType.WARNING)
		return

	unit_scene.queue_free()
	unit_scene.in_combat = false
	unit_scene = null
	slot_taken = false
