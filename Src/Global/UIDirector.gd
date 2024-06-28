extends Node

signal SCORE_CHANGED

signal HP_CHANGED
signal SHIELD_CHANGED

var score : int ##scrap as money?

var killcounter := {
	"ASTEROID": 0,
	
	"DRONE": 0,
	"HUNTER": 0,
	
	"TURRET": 0,
	#"ASTEROID": 0,
}

func _ready() -> void:
	set_score(0)

func add_score(value: int) -> void:
	score += value
	SCORE_CHANGED.emit(score)

func set_score(value: int) -> void:
	score = value
	SCORE_CHANGED.emit(score)

func add_to_killcount(index: String) -> void:
	if !killcounter.has(index):
		printerr("KILLCOUNTER HAS NO IDEX: ", index)
	killcounter[index] += 1
