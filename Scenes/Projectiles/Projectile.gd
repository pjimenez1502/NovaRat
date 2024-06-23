extends CharacterBody3D
class_name projectile

@export var speed : float
@export var damage : float = 1
@export var lifetime : float = 2
@onready var collision: CollisionShape3D = $CollisionShape3D


func _ready() -> void:
	set_inactive()

func _physics_process(delta: float) -> void:
	var collision := move_and_collide(-transform.basis.z * speed * delta)
	if collision:
		print(collision.get_collider())
		if collision.get_collider().has_method("damage"):
			collision.get_collider().damage(damage)
		set_inactive()
		print("hit")

func start() -> void:
	set_active()
	await get_tree().create_timer(lifetime).timeout
	set_inactive()

func set_active() -> void:
	set_collision_disabled(false)
	set_physics_process(true)
	
func set_inactive() -> void:
	set_collision_disabled(true)
	set_physics_process(false)
	global_position = Vector3(0,0,100)
	get_parent().available_bullet_pool.append(self)

func set_collision_disabled(value: bool) -> void:
	collision.set_deferred("disabled", value)
