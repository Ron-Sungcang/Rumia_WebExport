extends Node
class_name StageOverWorld

@export var stage_resource: StageRes

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

func initialize(res: StageRes) -> void:
	stage_resource = res
