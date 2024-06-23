extends Node3D

var target : Node3D
var target_look : Vector3

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var turret_head: MeshInstance3D = $Turret_1/TurretBase/TurretHead
@onready var weapon: ship_weapon = $Weapon
@onready var health: entity_health = $Health

@export var aim_variance : float
var innacuracy_vector : Vector3

func _ready() -> void:
	health.init_hp()

func _physics_process(delta: float) -> void:
	if target:
		target_look = lerp(target_look, target.global_position + innacuracy_vector, delta * 1)
		turret_head.look_at(target_look)
		weapon.shoot()

func damage(_damage:int) -> void:
	health.damage(_damage)
func death() -> void:
	queue_free()
	
## ACCURACY
func _on_innacuracy_timer_timeout() -> void:
	change_inaccuracy()
	
func change_inaccuracy() -> void:
	innacuracy_vector = Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1)) * aim_variance


## TARGETING AREAS
func _on_targeting_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("PLAYER") and !target:
		target = body

func _on_targeting_range_body_exited(body: Node3D) -> void:
	if body == target:
		target = null
