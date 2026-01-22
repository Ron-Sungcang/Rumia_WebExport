extends Node2D
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
		print("PartySlot, AddPartyScene, Party Slot:", slot_number, "is not empty")
		return
	elif get_child_count() > 0:
		print("PartySlot, AddPartyScene, Party Slot:", slot_number, "contains a child")
		return

	unit_scene = new_scene
	#add_child(unit_scene)
	unit_scene.reparent(self, false)

	unit_scene.in_combat = true
	slot_taken = true

	print("Successfully added Party unit:", unit_scene, "to slot:", slot_number, " at pos: ", unit_scene.position)
	print("Party slot pos: ", position)


func clear_scene() -> void:
	if not slot_taken:
		print("PartySlot, ClearScene, Party Slot:", slot_number, "is empty")
		return
	elif get_child_count() <= 0:
		print("PartySlot, ClearScene, Party Slot:", slot_number, "doesn't contain a child")
		return

	unit_scene.queue_free()
	unit_scene.in_combat = false
	unit_scene = null
	slot_taken = false
