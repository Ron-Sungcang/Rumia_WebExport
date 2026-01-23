extends Resource

class_name StageRes

@export var stage_number: float
@export var stage_name: String

@export var prev_stage: StageRes
@export var next_stage: StageRes

@export var stage_prefab: PackedScene
@export var background: Texture2D
