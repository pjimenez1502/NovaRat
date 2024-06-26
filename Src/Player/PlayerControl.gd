extends Node
class_name player_control

@onready var _player_ship: player_ship = $".."

var direction : Vector2
var braking : bool
var boosting : bool

const DOUBLETAP_DELAY : float = .25
var doubletap_time : float = DOUBLETAP_DELAY

func _process(delta: float) -> void:
	doubletap_time -= delta
	
	if Input.is_action_pressed("SHOOT"):
		_player_ship.weapon.shoot()

func _input(_event: InputEvent) -> void:
	var vertical : float = Input.get_axis("DOWN", "UP")
	var horizontal : float = Input.get_axis("LEFT", "RIGHT")
	#direction = Vector2(horizontal, vertical)
	direction = Vector2(easeInSine(horizontal), easeInSine(vertical))
	
	var bank_axis = Input.get_axis("DODGE_LEFT", "DODGE_RIGHT")
	_player_ship.set_bank(bank_axis)
	
	if check_left_dodge():
		_player_ship.dodge(-1)
	if check_right_dodge():
		_player_ship.dodge(1)
	
	braking = Input.is_action_pressed("SPEED_DOWN")
	boosting = Input.is_action_pressed("SPEED_UP")

var left_pressed : bool
var left_released : bool
func check_left_dodge() -> bool:
	if doubletap_time <= 0:
		left_pressed = false
		left_released = false
	if Input.get_action_strength("DODGE_LEFT") > .9:
		doubletap_time = DOUBLETAP_DELAY
		left_pressed = true
	if left_pressed and Input.get_action_strength("DODGE_LEFT") < .2:
		left_released = true
	if left_released and Input.get_action_strength("DODGE_LEFT") > .9:
		left_pressed = false
		left_released = false
		return true
	return false

var right_pressed : bool
var right_released : bool
func check_right_dodge() -> bool:
	if doubletap_time <= 0:
		right_pressed = false
		right_released = false
	if Input.get_action_strength("DODGE_RIGHT") > .9:
		doubletap_time = DOUBLETAP_DELAY
		right_pressed = true
	if right_pressed and Input.get_action_strength("DODGE_RIGHT") < .2:
		right_released = true
	if right_released and Input.get_action_strength("DODGE_RIGHT") > .9:
		right_pressed = false
		right_released = false
		return true
	return false

func easeInSine(x: float) -> float:
	return (1 - cos((x * PI) / 2)) * sign(x)
