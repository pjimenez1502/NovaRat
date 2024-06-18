extends CharacterBody3D
class_name projectile

@export var speed : float
@export var damage : float

func _physics_process(delta: float) -> void:
	move_and_collide(-transform.basis.z * speed * delta)
	
