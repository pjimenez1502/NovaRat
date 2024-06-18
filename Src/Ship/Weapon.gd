extends Node
class_name ship_weapon

@onready var timer: Timer = $Timer

@export var _projectile : PackedScene
@export var rpm : float = 400
@export var hardpoint_list : Array[hardpoint]

var timer_ready : bool = true

func _ready() -> void:
	timer.wait_time = 60/rpm
	pass

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
	var projectile_instance =  _projectile.instantiate() as projectile
	#print(projectile_instance.transform)
	add_child(projectile_instance)
	projectile_instance.global_transform = _hardpoint.global_transform


var available_bullet_count : int = 40
func create_init_bullets():
	pass


func _on_timer_timeout() -> void:
	timer_ready = true
