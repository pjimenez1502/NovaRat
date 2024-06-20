extends StaticBody3D
class_name obstacle

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var speed : float = 4
@export var hp : float = 50
@export var lifetime : float = 30
@export var value : int = 10

func _ready() -> void:
	set_inactive()

func _physics_process(delta: float) -> void:
	var collision := move_and_collide(transform.basis.z * speed * delta)
	#if collision:
		#collision.get_collider().damage(damage)
		#set_inactive()
		
func damage(damage : float) -> void:
	animation_player.play("Damage")
	hp -= damage
	if hp <= 0:
		death()

func death() -> void:
	# animation / particles
	ScoreDirector.add_score(value)
	set_inactive()

func start() -> void:
	set_active()
	await get_tree().create_timer(lifetime).timeout
	set_inactive()

func set_active() -> void:
	set_physics_process(true)
	
func set_inactive() -> void:
	set_physics_process(false)
	global_position = Vector3(0,0,10)
	get_parent().available_obstacle_pool.append(self)
