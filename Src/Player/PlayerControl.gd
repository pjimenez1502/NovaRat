extends Node
class_name player_control

@onready var _player_ship: player_ship = $".."

var direction : Vector2
var dodge_cooldown: float

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("SHOOT"):
		_player_ship.weapon.shoot()
	
	dodge_cooldown -= delta

func _input(_event: InputEvent) -> void:
	var vertical : float = Input.get_axis("DOWN", "UP")
	var horizontal : float = Input.get_axis("LEFT", "RIGHT")
	#direction = Vector2(horizontal, vertical)
	direction = Vector2(easeInSine(horizontal), easeInSine(vertical))
	
	var bank_axis = 0
	_player_ship.set_bank(bank_axis)
		
	var dodge_axis = Input.get_axis("DODGE_LEFT", "DODGE_RIGHT")
	check_dodge(dodge_axis)
	


func check_dodge(dodge_axis):
	dodge_axis = int(dodge_axis)
	if dodge_axis == 0:
		return
	if dodge_cooldown > 0:
		return
	
	var beat_accuracy = BeatDirector.check_beat_accuracy()
	match beat_accuracy:
		BeatDirector.ACCURACY.PERFECT:
			_player_ship.dodge(dodge_axis)
		BeatDirector.ACCURACY.GOOD:
			_player_ship.dodge(dodge_axis)
		BeatDirector.ACCURACY.OKAY:
			_player_ship.dodge(dodge_axis)
		BeatDirector.ACCURACY.MISS:
			pass
	dodge_cooldown = 0.6
	

func easeInSine(x: float) -> float:
	return (1 - cos((x * PI) / 2)) * sign(x)
