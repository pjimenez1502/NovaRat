extends Node

@onready var score_label: Label = %"Score Label"
@onready var score_animation: AnimationPlayer = $"Score Label/Score Animation"

@onready var shield: TextureProgressBar = %SHIELD
@onready var hp: TextureProgressBar = %HP


func _ready() -> void:
	UIDirector.SCORE_CHANGED.connect(update_score)
	
	UIDirector.HP_CHANGED.connect(update_hp)
	UIDirector.SHIELD_CHANGED.connect(update_shield)
	
	UIDirector.set_score(0)

func update_score(value : int) -> void:
	score_label.text = str(value)
	score_animation.play("ScoreChange")

func update_hp(value : int ) -> void:
	hp.value = value

func update_shield(value : int) -> void:
	shield.value = value
