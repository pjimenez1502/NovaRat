extends Node3D
class_name player_ship

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var aim_center: Node3D = $"../AimCenter"
@onready var collision: CollisionShape3D = $Collision

@export_group("Movement type")
@export var invert_y : bool
#@export var all_range : bool

@export_group("Components")
@export var play_area : Node3D
@export var _player_control : player_control
@export var weapon : ship_weapon
@export var stats : ship_stats

@export_group("Stats")
@export var speed : float = 6

var target_position : Vector3
var target_bank : float
var _bank : float
#var bank_boost : float

var velocity : Vector3
var look_target: Vector3


func _physics_process(delta: float) -> void:
	scale = Vector3.ONE
	aim(delta)
	bank(delta)
	
	forward(delta)

func calculate_speed() -> float:
	return speed
func forward(delta : float) -> void:
	var calculated_speed = calculate_speed()
	play_area.global_translate(-play_area.transform.basis.z * delta * calculated_speed)


func aim(delta : float) -> void:
	aim_center.position = position + Vector3(_player_control.direction.x * 20, _player_control.direction.y * 8, -20)
	look_target = lerp(look_target, aim_center.global_position , delta * 8)
	look_at(look_target)

func bank(delta : float) -> void:
	_bank = lerp(_bank, target_bank, delta * 6)
	rotate_object_local(Vector3.FORWARD, _bank)
func set_bank(angle : float) -> void:
	#bank_boost = angle * 0.5
	target_bank = deg_to_rad(clampf( angle * 90 + _player_control.direction.x * 40, -90, 90))

var current_lane = 0
func dodge(direction: float) -> void:
	if current_lane + direction > 1 or current_lane + direction < -1:
		#print("dodging out of rails")
		##play missed dodge
		return
	
	current_lane += direction
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "position", Vector3(current_lane * 6, 0, 0), 0.3)
	tween.parallel().tween_property(self, "rotation", Vector3(0, 0, -direction * PI*2), 0.3)
	
	#print("dodge: ", direction)



func damage(_damage: int, damager_group: String) -> void:
	stats.damage(_damage, damager_group)
