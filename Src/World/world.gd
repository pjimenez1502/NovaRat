extends Node3D
class_name world

@onready var _spawn_director: spawn_director = $SpawnDirector

@export var world_point : Vector3
@export var scroll_speed : float = 5

func _ready() -> void:
	_spawn_director.start_obstacle_spawn()
	
func _physics_process(delta: float) -> void:
	world_scroll(delta)

func world_scroll(delta: float) -> void:
	position.z += scroll_speed * delta
	world_point = position
