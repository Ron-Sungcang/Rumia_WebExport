extends Node
class_name EnemySlot

@export var slot_number: int
@export var slot_taken: bool = false

var unit_scene: EnemyUnit = null


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func add_enemy_scene(new_scene: EnemyUnit) -> void:
	if slot_taken:
		print("EnemySlot, AddEnemyScene, Enemy Slot:", slot_number, "is not empty")
		return
	elif get_child_count() > 0:
		print("EnemySlot, AddEnemyScene, Enemy Slot:", slot_number, "contains a child")
		return

	unit_scene = new_scene
	add_child(unit_scene)

	unit_scene.in_combat = true
	slot_taken = true

	print("Successfully added Enemy unit:", unit_scene, "to slot:", slot_number)


func clear_scene() -> void:
	if not slot_taken:
		print("EnemySlot, ClearScene, Enemy Slot:", slot_number, "is empty")
		return
	elif get_child_count() <= 0:
		print("EnemySlot, ClearScene, Enemy Slot:", slot_number, "doesn't contain a child")
		return

	unit_scene.queue_free()
	unit_scene.in_combat = false
	unit_scene = null
	slot_taken = false
