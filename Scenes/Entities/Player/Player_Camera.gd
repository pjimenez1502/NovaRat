extends Camera3D

@export var _player_ship : player_ship
@export var camera_offset : Vector3 = Vector3(0,3,5)
@export var camera_follow : bool = true

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if !camera_follow:
		return
	position = lerp(position, (_player_ship.position/2 + camera_offset), delta * 0.5)
	pass
