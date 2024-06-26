extends CharacterBody3D
class_name projectile

@onready var collision: CollisionShape3D = $CollisionShape3D

@export var speed : float
@export var _damage : float = 1
@export var lifetime : float = 2

@export var guided : bool
@export var target : Node3D
@export var guiding_power : float

func _ready() -> void:
	set_inactive()

func _physics_process(delta: float) -> void:
	var guiding_velocity : Vector3
	if guided and target:
		guiding_velocity = guiding(delta)
	
	var collision := move_and_collide(guiding_velocity + -transform.basis.z * speed * delta)
	if collision:
		#print(collision.get_collider())
		if collision.get_collider().has_method("damage"):
			collision.get_collider().damage(_damage)
		set_inactive()
		#print("hit")

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

func guiding(delta) -> Vector3:
	var direction = (target.global_position - global_position).normalized()
	return direction * (guiding_power * 1)

func set_guiding_target(_target : Node3D):
	target = _target
