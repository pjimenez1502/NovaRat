extends Node
class_name player_control

@onready var _player_ship: player_ship = $".."


var direction : Vector2

func _input(_event: InputEvent) -> void:
	var vertical : float = Input.get_axis("DOWN", "UP")
	var horizontal : float = Input.get_axis("LEFT", "RIGHT")
	direction = Vector2(horizontal, vertical)
	
	if _event.is_action_pressed("SHOOT"):
		_player_ship.weapon.shoot()


