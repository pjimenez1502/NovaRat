extends RigidBody3D
class_name obstacle

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var asteroid: Node3D = $Asteroid
@onready var health: entity_health = $Health

@export var BASE_SPEED : float = 4
var speed : float
@export var despawn : bool
@export var lifetime : float = 30
var rotation_value : Vector3

func _ready() -> void:
	set_inactive()

func _physics_process(delta: float) -> void:
	asteroid.rotate(rotation_value, 0.005)
	var collision := move_and_collide(transform.basis.z * speed * delta)
	
func damage(_damage:int) -> void:
	health.damage(_damage)
func death() -> void:
	set_inactive()

func start() -> void:
	set_active()
	set_random_rotation()
	speed = randf_range(BASE_SPEED - 1, BASE_SPEED + 1)
	if despawn:
		await get_tree().create_timer(lifetime).timeout
		set_inactive()

func set_active() -> void:
	set_physics_process(true)
	health.init_hp()
	
func set_inactive() -> void:
	set_physics_process(false)
	global_position = Vector3(0,0,100)
	get_parent().available_obstacle_pool.append(self)

func set_random_rotation() -> void:
	rotation = Vector3(randf_range(0, TAU),randf_range(0, TAU),randf_range(0, TAU))
	rotation_value = Vector3(randf(),randf(),randf()).normalized()
