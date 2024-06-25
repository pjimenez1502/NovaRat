extends Node3D

var target : Node3D
var target_look : Vector3

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var turret_head: MeshInstance3D = $Turret/TurretBase/TurretHead
@onready var weapon: ship_weapon = $Weapon
@onready var health: entity_health = $Health
@onready var collision: CollisionShape3D = $Collision

@export var aim_variance : float
@export var score_value : float = 100
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
	turret_head.visible = false
	collision.disabled = true
	set_physics_process(false)
	UIDirector.add_score(score_value)
	
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
