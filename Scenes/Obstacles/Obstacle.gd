extends Node3D
class_name obstacle

@export var hp : float = 50

func damage(damage : float) -> void:
	hp -= damage
	if hp <= 0:
		death()

func death() -> void:
	# animation / particles
	queue_free()
