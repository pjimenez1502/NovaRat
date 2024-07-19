extends Node3D
class_name player_ship

@onready var aim_center: Node3D = $"../AimCenter"
@onready var collision: CollisionShape3D = $Collision
@onready var the_funk_machine: funk_machine = $TheFunkMachine

@onready var engine_push_sprite: AnimatedSprite3D = $Engine_push

@export_group("Components")
@export var play_area : Node3D
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

func _ready() -> void:
	the_funk_machine.ENGINE.connect(engine_push)
	the_funk_machine.GUN.connect(shoot)
	the_funk_machine.DASH.connect(dodge)

func _physics_process(delta: float) -> void:
	scale = Vector3.ONE
	forward(delta)
	ship_drag(delta)

func ship_drag(delta: float) -> void:
	position.z += delta
	if position.z >= 6:
		print("ship too back")

func calculate_speed() -> float:
	return speed * 0.41875
func forward(delta : float) -> void:
	var calculated_speed: float = calculate_speed()
	play_area.global_translate(-play_area.transform.basis.z * delta * calculated_speed)

var engine_tween: Tween
var last_pos: float
func engine_push() -> void:
	#print("pos: ", global_position.z - last_pos)
	last_pos = global_position.z
	engine_tween = get_tree().create_tween()
	engine_tween.tween_property(self, "position:z", position.z - 1, 0.2)
	#engine_tween.tween_property(self, "position:z", 2, 4)
	engine_push_sprite.play("default")
	

func shoot() -> void:
	weapon.shoot()

var current_lane: int = 0
func dodge(direction: float) -> void:
	if current_lane + direction > 1 or current_lane + direction < -1:
		print("dodging out of rails")
		return
	
	current_lane += direction
	var tween := get_tree().create_tween()
	tween.parallel().tween_property(self, "position", Vector3(current_lane * 6, 0, position.z), 0.3)
	tween.parallel().tween_property(self, "rotation", Vector3(0, 0, -current_lane * PI*2), 0.3)




func damage(_damage: int, damager_group: String) -> void:
	stats.damage(_damage, damager_group)
