extends Node

@onready var score_label: Label = %"Score Label"


func _ready() -> void:
	ScoreDirector.SCORE_CHANGED.connect(update_score)

func update_score(value : int) -> void:
	score_label.text = str(value)
