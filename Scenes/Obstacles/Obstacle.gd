extends Node3D
class_name obstacle

@export var hp : float = 50

func _on_hit(damage : float) -> void:
	hp -= damage
	if hp <= 0:
		death()

func death() -> void:
	# animation / particles
	queue_free()
