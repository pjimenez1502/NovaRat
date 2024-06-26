extends Node
class_name ship_weapon

@onready var timer: Timer = $Timer

@export var _projectile : PackedScene
@export var rpm : float = 400
@export var hardpoint_list : Array[hardpoint]

@export var pool_size : int
var timer_ready : bool = true

func _ready() -> void:
	init_available_bullet_pool()
	timer.wait_time = 60/rpm

func shoot() -> void:
	if !timer_ready:
		return
	
	timer_ready = false
	timer.start()
	iterate_hardpoints()

func shoot_targeted(target : Node3D) -> void:
	iterate_hardpoints(target)

func iterate_hardpoints(target : Node3D = null) -> void:
	for _hardpoint : hardpoint in hardpoint_list:
		if _hardpoint.enabled:
			if target:
				_hardpoint.aim(target.global_position + -target.global_transform.basis.z * 4)
			instantiate_projectile(_hardpoint, target)

func instantiate_projectile(_hardpoint : hardpoint, target : Node3D) -> void:
	var projectile_instance = get_bullet()
	if projectile_instance:
		projectile_instance.global_transform = _hardpoint.global_transform
		if target:
			projectile_instance.set_guiding_target(target)

func _on_timer_timeout() -> void:
	timer_ready = true


var available_bullet_pool : Array[projectile]
var used_bullet_pool : Array[projectile]
func init_available_bullet_pool():
	for i in pool_size:
		var bullet: projectile = _projectile.instantiate() as projectile
		add_child(bullet)
		bullet.global_position = Vector3(0,0,100)

func get_bullet() -> projectile:
	if available_bullet_pool.size() > 0:
		var bullet : projectile = available_bullet_pool.pop_front()
		used_bullet_pool.append(bullet)
		bullet.start()
		return bullet
	else:
		print("no bullets")
		return null
