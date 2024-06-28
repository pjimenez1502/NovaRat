extends Node

@onready var staging_timer: Timer = $Timer

@onready var target_point: Node3D = $TargetPoint
@onready var _player_ship: player_ship = $"../PlayArea/PlayerShip"

##TRIGGERAREAS
@onready var tutorial_drone_spawn_area: Area3D = $TutorialDroneSpawnArea
@onready var asteroid_trial_fail_area: Area3D = $AsteroidTrialFailArea
@onready var enemy_spawn_area: Area3D = $EnemySpawnArea


@export var drone_prefab : PackedScene
@export var carrier : Node3D


var stage : int = 0
var stage_finished : bool

var stage_dictionary := {
	0 : controls_tutorial,
	1 : asteroid_trial,
	2 : signal_appeared,
	3 : return_to_carrier,
}

var stage_checks := {
	0 : no_check,
	1 : asteroid_trial_check,
	2 : drone_killed_check,
	3 : no_check,
}

func _ready() -> void:
	call_stage()

func check_advance_stage() -> void:
	print("CURRENT STAGE: ", stage, " - Finished = ", stage_finished, " Checks: ", stage_checks[stage])
	if stage_checks[stage].call():
		print("check success")
		stage_finished = true
		
	if stage_finished:
		stage += 1
		call_stage()
		return
	

func call_stage() -> void:
	stage_dictionary[stage].call()
	stage_finished = false

## STAGE 0
func controls_tutorial() -> void:
	await get_tree().create_timer(1).timeout
	DialogDirector.new_dialog("lizzard","Alright Cadet, \nlooks like takeoff went without issues.")
	
	await get_tree().create_timer(8).timeout
	DialogDirector.new_dialog("lizzard","I will be your instructor today. \nFollow my directions and you will end your first flight in one piece.")
	
	await get_tree().create_timer(8).timeout
	DialogDirector.new_dialog("lizzard","Let's test your basic controls. \nMove your joystick to manouver the ship.")
	
	await get_tree().create_timer(8).timeout
	DialogDirector.new_dialog("lizzard","Good. \nYou can Roll to turn without messing your aim \nor to simply turn faster.")
	
	await get_tree().create_timer(8).timeout
	DialogDirector.new_dialog("lizzard","Use your thrusters to speed up and slow down.")
	
	
	
	await get_tree().create_timer(8).timeout
	DialogDirector.new_dialog("lizzard","Press the trigger to fire your main weapons. \nWeapons free. You are authorized to shoot.")
	
	await get_tree().create_timer(8).timeout
	DialogDirector.new_dialog("lizzard","Your secondary weapons will see less use, \nbut they usually pack a bigger punch than your primary ones.")
	await get_tree().create_timer(8).timeout
	DialogDirector.new_dialog("lizzard","You will have to choose what to carry \nbefore you leave the carrier.\nEvery type of ordinance will be useful \nin different situations.")
	await get_tree().create_timer(8).timeout
	DialogDirector.new_dialog("lizzard","Learning which one is right for the mission and when to employ them \nis a crucial skill you will develop with experience.")
	
	stage_finished = true



## STAGE 1
func asteroid_trial() -> void:
	await get_tree().create_timer(5).timeout
	DialogDirector.new_dialog("lizzard","Heads up. You are approaching an asteroid field. \nDestroy two to show me that you were actually listening.")

func asteroid_trial_check() -> bool:
	if UIDirector.killcounter["ASTEROID"] >= 2:
		DialogDirector.new_dialog("lizzard","Good. That will teach them.")
		return true
	else:
		return false

func _on_asteroid_trial_fail_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("PLAYER"):
		asteroid_trial_failed()
func asteroid_trial_failed() -> void:
	DialogDirector.new_dialog("lizzard","You will have to improve your aim, cadet.")
	stage_finished = true



## STAGE 2
func signal_appeared() -> void:
	asteroid_trial_fail_area.get_child(0).set_deferred("disabled", true)
	
	await get_tree().create_timer(6).timeout
	DialogDirector.new_dialog("lizzard","Listen up, Cadet.\nOur sensors are reading an unidentified signal near the training area.")
	await get_tree().create_timer(6).timeout
	DialogDirector.new_dialog("lizzard","Just forward from your vector.\nCheck it out and report back.")
	target_point.visible = true

func _on_tutorial_drone_area_enter(body: Node3D) -> void:
	if body.is_in_group("PLAYER"):
		spawn_tutorial_drone()

func spawn_tutorial_drone() -> void:
	tutorial_drone_spawn_area.get_child(0).set_deferred("disabled", true)
	target_point.visible = false
	var drone = drone_prefab.instantiate()
	add_child(drone)
	drone.global_position = _player_ship.global_position + Vector3(0, 20, -30)
	drone.dummy_target = _player_ship.get_parent()
	drone.find_target()
	drone.decide_point_relative_to_target()
	
	await get_tree().create_timer(2).timeout
	DialogDirector.new_dialog("lizzard","What is that?")
	await get_tree().create_timer(6).timeout
	DialogDirector.new_dialog("lizzard","Unidentified contact declared as hostile.\nEngage and destroy the target.")

func drone_killed_check() -> bool:
	return UIDirector.killcounter["DRONE"] >= 1



## STAGE 3
func return_to_carrier() -> void:
	carrier.global_position = Vector3(0,-16 ,-1000)
	target_point.global_position = Vector3(0,0,-1000)
	
	await get_tree().create_timer(4).timeout
	DialogDirector.new_dialog("lizzard","Cadet! The carrier is under attack!.")
	await get_tree().create_timer(2).timeout
	DialogDirector.new_dialog("lizzard","Return inmmediatelly and provide support\nuntil the main fighter wing is deployed.")
	enable_all_range_mode()
	
	
	## EXPLAIN ALL RANGE MODE
	target_point.visible = true
	enemy_spawn_area.get_child(0).set_deferred("disabled", false)
	

func enable_all_range_mode() -> void:
	_player_ship.all_range = true
	
func _on_enemy_spawn_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("PLAYER"):
		spawn_swarm()
var field_spawn_count = 20
func spawn_swarm() -> void:
	print("spawnswarm")
	for i in field_spawn_count:
		var _drone = drone_prefab.instantiate()
		add_child(_drone)
		_drone.global_position = get_random_position_in_field(carrier.global_position, 100, 40)
		

func get_random_position_in_field(field_position: Vector3, field_radius: float, field_height: float) -> Vector3:
	return field_position + Vector3(randf_range(-1,1), 0, randf_range(-1,1)) * field_radius + Vector3(0,randf_range(-1,1) * field_height, 0)
	




#################
func _on_timer_timeout() -> void:
	check_advance_stage()

func no_check() -> bool:
	return false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_P:
			Engine.time_scale = 15
		if event.is_pressed() and event.keycode == KEY_O:
			Engine.time_scale = 1






