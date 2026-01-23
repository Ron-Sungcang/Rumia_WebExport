extends Node2D

class_name Stage

@export var stage_completed: bool = false

# Property equivalent to C# StageCompleted
#var StageCompleted: bool:
	#get:
		#return stage_completed
	#set(value):
		#stage_completed = value
		#
		# Future logic
		# if stage_completed and next_stage != null:
		#     next_stage.visible = true


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass
