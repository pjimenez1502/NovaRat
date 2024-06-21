extends Node

@onready var score_label: Label = %"Score Label"
@onready var score_animation: AnimationPlayer = $"Score Animation"


func _ready() -> void:
	ScoreDirector.SCORE_CHANGED.connect(update_score)
	ScoreDirector.set_score(0)

func update_score(value : int) -> void:
	score_label.text = str(value)
	score_animation.play("ScoreChange")
