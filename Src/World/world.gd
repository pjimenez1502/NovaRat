extends Node3D
class_name world

@export var _player_ship : player_ship
@export var world_point : Vector3

func world_move() -> void:
	world_point -= _player_ship.ship_movement.velocity
	_player_ship.position += _player_ship.ship_movement.velocity
	position = world_point
