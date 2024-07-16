extends Node3D

@export var targetpoints: Array[Node3D]

func _ready() -> void:
	show_weakspots(false)

func show_weakspots(value: bool) -> void:
	for targetpoint in targetpoints:
		targetpoint.visible = value

func start_charge() -> void:
	pass
	

func damage_sac() -> void:
	pass
	
