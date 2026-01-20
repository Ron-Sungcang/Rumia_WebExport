extends Node

#The StageManager should be added to a node in the OverWorld scene
#Then when a stage is selected, list it here.  When a stage is played send the selected stage

# Exported for testing / setup
@export var selected_combat_res: CombatStageRes
@export var overworld_stages: Array[StageOverWorld] = []

func _ready() -> void:
	print("Stage manager start, with combat res: ", selected_combat_res)


func _process(delta: float) -> void:
	pass
