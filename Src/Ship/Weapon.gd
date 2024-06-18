extends Node
class_name ship_weapon

@onready var timer: Timer = $Timer

@export var _projectile : PackedScene
@export var rpm : float = 400
@export var hardpoint_list : Array[hardpoint]

var timer_ready : bool = true

func _ready() -> void:
	init_available_bullet_pool()
	timer.wait_time = 60/rpm

func shoot() -> void:
	if !timer_ready:
		return
	
	timer_ready = false
	timer.start()
	fdsgfdsgf()

func fdsgfdsgf() -> void:
	for _hardpoint : hardpoint in hardpoint_list:
		if _hardpoint.enabled:
			instantiate_projectile(_hardpoint)

func instantiate_projectile(_hardpoint : hardpoint) -> void:
	var projectile_instance = get_bullet()
	if projectile_instance:
		projectile_instance.global_transform = _hardpoint.global_transform


var available_bullet_pool_size : int = 200
var available_bullet_pool : Array[projectile]
var used_bullet_pool : Array[projectile]
func init_available_bullet_pool():
	for i in available_bullet_pool_size:
		var bullet: projectile = _projectile.instantiate() as projectile
		add_child(bullet)

func get_bullet() -> projectile:
	if available_bullet_pool.size() > 0:
		var bullet : projectile = available_bullet_pool.pop_front()
		used_bullet_pool.append(bullet)
		bullet.start()
		return bullet
	else:
		print("no bullets")
		return null

func _on_timer_timeout() -> void:
	timer_ready = true
