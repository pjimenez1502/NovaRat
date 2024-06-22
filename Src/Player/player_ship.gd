extends Node3D
class_name player_ship

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var aim_center: Node3D = $"../AimCenter"

@export var all_range : bool

@export var play_area : Node3D
@export var _player_control : player_control
@export var weapon : ship_weapon
@export var stats : ship_stats

@export var speed : float = 6
@export var boost_power : float = 1.4
@export var brake_power : float = 0.8

@export var dodge_distance : float = 1.5
@export var dodge_cooldown : float = 2

var curr_dodge_cooldown : float

var target_position : Vector3
var target_bank : float
var _bank : float
var bank_boost : float

var velocity : Vector3
var look_target: Vector3

var dash : Vector3



func _physics_process(delta: float) -> void:
	steer(delta)
	bank(delta)
	
	forward(delta)
	if all_range:
		check_turning(delta)
	curr_dodge_cooldown -= delta

func calculate_speed() -> float:
	return speed * (brake_power if _player_control.braking else 1) * (boost_power if _player_control.boosting else 1)

func forward(delta : float) -> void:
	var calculated_speed = calculate_speed()
	play_area.global_translate(-play_area.transform.basis.z * delta * calculated_speed)

func steer(delta : float) -> void:
	target_position = position + Vector3(_player_control.direction.x + bank_boost, _player_control.direction.y, 0)
	
	target_position.x = clampf(target_position.x, -6.5, 6.5)
	target_position.y = clampf(target_position.y, -2, 4)
	
	target_position.z = 0 + -2 if _player_control.boosting else 0 + 2 if _player_control.braking else 0
	
	position = lerp(position, target_position , delta * 6)
	
	aim_center.position = Vector3(_player_control.direction.x * 30, _player_control.direction.y * 12, -30)
	look_target = lerp(look_target, aim_center.global_position , delta * 8)
	look_at(look_target)

func check_turning(delta: float) -> void:
	var turning_offset : float = position.x
	if turning_offset > 5 and _player_control.direction.x > 0:
		play_area.rotate_y(-_player_control.direction.x * delta * .8)
		
	if turning_offset < -5 and _player_control.direction.x < 0:
		play_area.rotate_y(-_player_control.direction.x * delta * .8)

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
	bank_boost = angle * 0.5
	target_bank = deg_to_rad(clampf( angle * 90 + _player_control.direction.x * 40, -90, 90))

func roll(direction : float) -> void:
	pass
