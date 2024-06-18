extends Node3D
class_name player_ship

@export var _player_control : player_control
@export var weapon : ship_weapon

var target_position : Vector3
var velocity : Vector3
var look_target: Vector3

func _physics_process(delta: float) -> void:
	steer(delta)

func steer(delta : float) -> void:
	target_position = position + Vector3(_player_control.direction.x, _player_control.direction.y, 0)
	target_position.x = clampf(target_position.x, -6, 6)
	target_position.y = clampf(target_position.y, -2, 4)
	
	position = lerp(position, target_position, delta * 6)
	
	look_target = lerp(look_target, position + Vector3(_player_control.direction.x * 15, _player_control.direction.y * 6, -10), delta * 8)
	look_at(look_target)
