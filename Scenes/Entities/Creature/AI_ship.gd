extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health: entity_health = $Health
@onready var collision: CollisionShape3D = $Collision
@onready var weapon: ship_weapon = $WEAPON


@export var speed : float = 4

@export var dummy_target : Node3D
@export var position_variance_distance : float
@export var position_variance_width : float

@export var score_value : float = 200

var target_object : Node3D
var target_point: Vector3
var direction : Vector3
var target_direction : Vector3
var relative_target : Vector3

func _ready() -> void:
	health.init_hp()
	
	find_target()
	decide_point_relative_to_target()

func _physics_process(delta: float) -> void:
	move(delta)
	point_nose(delta)
	
	follow_relative_point()

func damage(_damage:int) -> void:
	health.damage(_damage)
func death() -> void:
	
	UIDirector.add_score(score_value)
	queue_free()
	
func move(delta : float) -> void:
	var distance = (target_point - global_position).length()
	target_direction = global_position.direction_to(target_point).clamp(-Vector3.ONE, Vector3.ONE) * clampf(distance/10, 0, 0.1)
	direction = lerp(direction, target_direction, delta)
	velocity = direction * speed
	
	move_and_collide(velocity)

func point_nose(delta : float) -> void:
	look_at(global_position + velocity.normalized())

func find_target() -> void:
	if dummy_target:
		target_object = dummy_target
		return

func decide_point_relative_to_target() -> void:
	if !target_object:
		return
	var target_basis = target_object.global_transform.basis
	relative_target = target_basis.x * randf_range(-position_variance_width,position_variance_width) + target_basis.y * randf_range(-position_variance_width,position_variance_width) + target_basis.z * -position_variance_distance
	if check_ready_to_fire():
		charge_shoot()

func follow_relative_point() -> void:
	if !target_object:
		return
	target_point = target_object.global_position + relative_target

@export var charging : bool
func check_ready_to_fire() -> bool:
	if charging:
		return false
	#print((target_object.global_position - global_position).length())
	var distance = (target_object.global_position - global_position).length()
	if distance > 15 and distance < 25:
		return true
	return false

func charge_shoot() -> void:
	animation_player.play("Charge_Shoot")

func shoot():
	var shoot_target = target_object
	if shoot_target.is_in_group("PLAYER"):
			shoot_target = target_object.get_child(0)
	weapon.shoot_targeted(shoot_target)
