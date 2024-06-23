extends Node
class_name ship_stats

@onready var player_ship: player_ship = $".."

@export var hull : float = 4
@export var shield : float = 1

func _ready() -> void:
	show_status()
	
func show_status() -> void:
	UIDirector.HP_CHANGED.emit(hull)
	UIDirector.SHIELD_CHANGED.emit(shield)

func damage(damage : float) -> void:
	player_ship.animation_player.play("Damage")
	
	shield -= damage
	if shield < 0:
		hull += shield
		shield = 0
	
	show_status()
	
	if hull <= 0:
		death()

func death() -> void:
	print("player dead")

var terrain_damage : float = 2
func _on_hit_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("PLAYER"):
		return
	
	if body.is_in_group("TERRAIN"):
		damage(terrain_damage)
		return
		
	if body.damage:
		damage(body.damage)
