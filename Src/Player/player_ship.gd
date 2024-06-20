extends Node3D
class_name player_ship

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var _player_control : player_control
@export var weapon : ship_weapon
@export var stats : ship_stats

@export var dodge_distance : float = 1.5
@export var dodge_cooldown : float = 2
var curr_dodge_cooldown : float

var target_position : Vector3
var target_bank : float
var _bank : float

var velocity : Vector3
var look_target: Vector3

var dash : Vector3

func _physics_process(delta: float) -> void:
	steer(delta)
	bank(delta)
	curr_dodge_cooldown -= delta

func steer(delta : float) -> void:
	target_position = position + Vector3(_player_control.direction.x, _player_control.direction.y, 0) + (Vector3(_bank, 0, 0) * 0.5)
	target_position.x = clampf(target_position.x, -6, 6)
	target_position.y = clampf(target_position.y, -2, 4)
	 
	position = lerp(position, target_position , delta * 6)
	
	look_target = lerp(look_target, position + Vector3(_player_control.direction.x * 30, _player_control.direction.y * 12, -20), delta * 8)
	look_at(look_target)

func dodge(direction : int) -> void:
	if curr_dodge_cooldown > 0:
		return
	#dash.x += direction * dodge_distance
	curr_dodge_cooldown = dodge_cooldown
	if direction == 1:
		animation_player.play("Dash R")
	elif direction == -1:
		animation_player.play("Dash L")
	
func clear_dash() -> void:
	dash = Vector3.ZERO

func bank(delta : float) -> void:
	_bank = lerp(_bank, target_bank, delta * 6)
	rotate_object_local(Vector3.FORWARD, _bank)

func set_bank(angle : float) -> void:
	target_bank = deg_to_rad(angle)

func roll(direction : float) -> void:
	pass
