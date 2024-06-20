extends Node
class_name spawn_director

@onready var obstacle_spawn_timer: Timer = $ObstacleSpawnTimer

@export var obstacle_list : Array[PackedScene]
@export var spawn_area : Vector3

var obstacle_pool_size : int = 60
var available_obstacle_pool : Array[obstacle]
var used_obstacle_pool : Array[obstacle]

func start_obstacle_spawn() -> void:
	init_obstacle_pool()
	obstacle_spawn_timer.start()

func spawn_obstacle() -> void:
	var _obstacle = get_obstacle()
	if _obstacle:
		var position = Vector3(randf_range(-spawn_area.x, spawn_area.x), randf_range(-spawn_area.y, spawn_area.y), randf_range(-spawn_area.z, spawn_area.z)-20)
		_obstacle.position = position
func _on_obstacle_spawn_timer_timeout() -> void:
	spawn_obstacle()



func init_obstacle_pool() -> void:
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


