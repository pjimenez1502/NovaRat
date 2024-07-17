extends CharacterBody3D

enum TAGS {DRONE, HUNTER}
@export var tag : TAGS

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health: entity_health = $Health
@onready var collision: CollisionShape3D = $Collision
@onready var weapon: ship_weapon = $WEAPON

@export var speed : float = 4
@export var score_value : float = 100


var current_lane: int = 0
var time_on_screen: float ## track how much time the enemy has been on screen. if too much, leave. (less score for the player if not fast enough)

func _ready() -> void:
	health.init_hp()

func _physics_process(delta: float) -> void:
	pass

func start(lane: int, z_pos: int, time: float = 40) -> void:
	current_lane = lane
	global_position = Vector3(lane * 6, 0, z_pos)
	time_on_screen = time

#func on_forward_raycast_collision() -> void:
	#swap_lane()

func swap_lane() -> void: ## randomly on behaviour or if going to hit an asteroid?
	var direction: int
	match current_lane:
		0:
			direction = randi_range(-1,1)
		1:
			direction = randi_range(-1,0)
		-1:
			direction = randi_range(0,1)
	
	current_lane += direction
	
	var tween := get_tree().create_tween()
	tween.parallel().tween_property(self, "position", Vector3(current_lane * 6, 0, 0), 0.3)
	tween.parallel().tween_property(self, "rotation", Vector3(0, 0, -direction * PI*2), 0.3)


func exit_screen() -> void: ## move forward or upwards outisde of the screen 
	pass
