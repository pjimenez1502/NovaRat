extends Node3D
class_name hardpoint

@export var enabled : bool = true

func aim(position : Vector3) -> void:
	look_at(position)
