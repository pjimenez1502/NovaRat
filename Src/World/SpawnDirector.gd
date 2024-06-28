extends Node
class_name spawn_director

@onready var _world: world = $".."
@onready var obstacle_spawn_timer: Timer = $ObstacleSpawnTimer

@export var obstacle_list : Array[PackedScene]

@export_group("Field Spawning")
@export var field_enabled : bool
@export var field_radius : float
@export var field_height : float
@export var field_spawn_count : float
@export var field_position : Vector3

@export_group("Continuous Spawning")
@export var continuous_enabled : bool
@export var distance_to_playarea : float
@export var spawn_area : Vector3

var obstacle_pool_size : int = 60
var available_obstacle_pool : Array[obstacle]
var used_obstacle_pool : Array[obstacle]

func start_population() -> void:
	if field_enabled:
		start_field_population()
	if continuous_enabled:
		start_continuous_population()

func start_field_population() -> void:
	for i in field_spawn_count:
		var _obstacle = obstacle_list[randi_range(0, obstacle_list.size()-1)].instantiate()
		add_child(_obstacle)
		_obstacle.start()
		_obstacle.position = get_random_position_in_field()
		

func get_random_position_in_field() -> Vector3:
	return field_position + Vector3(randf_range(-1,1), 0, randf_range(-1,1)) * field_radius + Vector3(0,randf_range(-1,1) * field_height, 0)




## Continous spawning
func start_continuous_population() -> void:
	init_obstacle_pool()
	obstacle_spawn_timer.start()

func spawn_obstacle() -> void:
	var _obstacle = get_obstacle()
	if _obstacle:
		var position = _world.play_area.position + _world.play_area.transform.basis.z * -distance_to_playarea + Vector3(randf_range(-spawn_area.x, spawn_area.x), randf_range(-spawn_area.y, spawn_area.y), randf_range(-spawn_area.z, spawn_area.z))
		_obstacle.position = position

func _on_obstacle_spawn_timer_timeout() -> void:
	spawn_obstacle()


## Pooling for continuous population
func init_obstacle_pool() -> void: ## !!!!!! Right now, all asteroids start visible in the center of the map.
	for i in obstacle_pool_size:
		var _obstacle = obstacle_list[randi_range(0, obstacle_list.size()-1)].instantiate()
		add_child(_obstacle)
		
	print("sdssd ",available_obstacle_pool.size())

func get_obstacle() -> obstacle:
	if available_obstacle_pool.size() > 0:
		var _obstacle : obstacle = available_obstacle_pool.pop_front()
		used_obstacle_pool.append(_obstacle)
		_obstacle.start()
		return _obstacle
	else:
		print("no obstacles")
		return null


