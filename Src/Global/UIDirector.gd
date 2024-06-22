extends Node

signal SCORE_CHANGED

signal HP_CHANGED
signal SHIELD_CHANGED

var score : int ##scrap as money?

func _ready() -> void:
	set_score(0)

func add_score(value : int) -> void:
	score += value
	SCORE_CHANGED.emit(score)

func set_score(value : int) -> void:
	score = value
	SCORE_CHANGED.emit(score)

