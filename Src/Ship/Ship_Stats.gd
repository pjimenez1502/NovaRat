extends Node
class_name ship_stats

@onready var player_ship: player_ship = $".."

@export var hull : float = 4
@export var shield : float = 1

@export var immunity_period : float = 0.2
var immune : bool

func _ready() -> void:
	show_status()
	
func show_status() -> void:
	UIDirector.HP_CHANGED.emit(hull)
	UIDirector.SHIELD_CHANGED.emit(shield)

func damage(damage: float, damager_group: String) -> void:
	if immune:
		return
	
	shield -= damage
	if shield < 0:
		hull += shield
		shield = 0
	
	player_ship.animation_player.play("Damage")
	show_status()
	if hull <= 0:
		death()
	immune = true
	await get_tree().create_timer(immunity_period).timeout
	immune = false

func death() -> void:
	print("player dead")



var terrain_damage : float = 2
func _on_hit_area_body_entered(body: Node3D) -> void:
	pass
	#if body.is_in_group("PLAYER"):
		#return
	#
	#if body.is_in_group("TERRAIN"):
		#damage(terrain_damage)
		#return
	#
	#if body._damage:
		#damage(body._damage)
